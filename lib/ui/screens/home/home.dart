import 'dart:convert';
import 'package:app/Project/Pages/settings_screen.dart';
import 'package:app/components/profile/widget/profile.dart';
import 'package:app/model/blog_model.dart';
import 'package:app/models/Advert.dart';
import 'package:app/models/Anchors.dart';
import 'package:app/pages/dialogs/flash_page.dart';
import 'package:app/ui/screens/home/updates_page.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:app/configs/colors.dart';
import 'package:app/core/extensions/context.dart';
// import 'package:app/data/categories.dart';
import 'package:app/models/NewsArticle.dart';
import 'package:app/models/Verses.dart';
import 'package:app/network_utils/api.dart';

import 'package:app/pages/lists/anchors_page.dart';
import 'package:app/pages/lists/lists.dart';
import 'package:app/routers/routes.dart';
import 'package:app/services/webservice.dart';
import 'package:app/ui/screens/blog_home_screen.dart';
import 'package:app/ui/screens/home/WebViewPage.dart';
import 'package:app/ui/screens/home/updates_page2.dart';
import 'package:app/ui/widgets/poke_category_card.dart';
import 'package:app/ui/widgets/poke_container.dart';
import 'package:app/ui/widgets/poke_news.dart';
import 'package:app/ui/widgets/spacer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:app/configs/colors.dart';
import 'package:app/domain/entities/category.dart';
import 'package:app/routers/routes.dart';

part 'widgets/header_app_bar.dart';
part 'widgets/daily_verse.dart';
part 'widgets/pokemon_news.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _scrollController = ScrollController();
  List<Blog> _newsArticles = List<Blog>();
  List<Verses> _verses = List<Verses>();
  var _isLoading = true, _isInit = false;
  List<Anchors> _anchors = List<Anchors>();
  List<Anchors> _bulletins = List<Anchors>();

  double appBarHeight = 0;
  bool showTitle = false;
  // List<NewsArticle> _newsArticles;
  String name = "";
  String email = "";
  String phone = "";
  String id = "";

  List<Category> categories = [
    Category(name: 'Anchor', color: AppColors.teal, route: Routes.expandable),
    Category(name: 'NVM', color: AppColors.red, route: Routes.expandable),
    Category(
        name: 'NIFES Updates', color: AppColors.blue, route: Routes.expandable),
    Category(name: 'Bible', color: AppColors.yellow, route: Routes.pokedex),
    Category(
        name: 'Prayer Bulletin',
        color: AppColors.purple,
        route: Routes.bulletin),
    Category(
        name: 'Land of Promise',
        color: AppColors.brown,
        route: Routes.expandable),
  ];
  List<Advert> adverts = List<Advert>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (!_isInit) {
      _simulateLoad();
    }
    _isInit = true;
  }

  void _populateArticles() async {
    await Webservice().load(Verses.all).then((newsArticles) => {
          setState(() => {_verses = newsArticles})
        });
  }

  Future<void> _populateBulletins() async {
    final http.Response response = await http
        .get(Uri.parse("https://nifes.org.ng/api/mobile/bulletin/index"));
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['bulletins'].forEach((newsDetail) {
      final Anchors news = Anchors(
          description: newsDetail['description'],
          verses: newsDetail['verses'],
          uuid: newsDetail['uuid'],
          createdAt: newsDetail['created_at'],
          year: Year.fromJson(newsDetail['year']),
          month: Year.fromJson(newsDetail['month']),
          day: Year.fromJson(newsDetail['day']));
      setState(() {
        _bulletins.add(news);
        _isLoading = false;
      });
    });
  }

  _simulateLoad() {
    Future.delayed(Duration(seconds: 5), () {
      _populatePosts();
      _populateAdvert();
      _populateArticles();
      _populateAnchors();
      _populateBulletins();

      setState(() async {
        email = await getValue('email') ?? "";
        name = await getValue('name') ?? "";
        phone = await getValue('phone') ?? "";
        id = await getValue('id') ?? "";
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  getValue(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(name);
    return stringValue;
  }

  void _populateAdvert() async {
    // Webservice().load(Advert.all).then((newsArticles) => {
    //       setState(() => {adverts = newsArticles})
    //     });

    final http.Response response =
        await http.get(Uri.parse(Constants.HEADLINE_ADVERT_URL));
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['data'].forEach((newsDetail) {
      //  print("thees${newsDetail['image'].substring(22)}");
      final Advert news = Advert(
          id: newsDetail['id'],
          title: newsDetail['title'] ?? "",
          descrption: newsDetail['body'] ?? "",
          urlToImage:
              newsDetail['image'] ?? Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
          // 'https://nifes.org.ng/' + newsDetail['image'].substring(19) ??
          // Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
          slug: newsDetail['slug'],
          time: newsDetail['created_at']);
      setState(() {
        adverts.add(news);
      });
    });
    _openFlashDialog(this.context);
  }

  Future<void> _populatePosts() async {
    final http.Response response =
        await http.get(Uri.parse(Constants.HEADLINE_NEWS_URL));
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['data'].forEach((newsDetail) {
      //  print("thees${newsDetail['image'].substring(22)}");
      final Blog news = Blog(
          name: newsDetail['title'],
          content: newsDetail['body'],
          imageUrl:
              newsDetail['image'] ?? Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
          // 'https://nifes.org.ng/' + newsDetail['image'].substring(19) ??
          // Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
          slug: newsDetail['slug'],
          created_at: newsDetail['created_at']);
      setState(() {
        _newsArticles.add(news);
      });
    });
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  Future<void> _openFlashDialog(BuildContext context) async {
    String id = await getValue('ad_id') ?? "";
    if (adverts.length > 0) {
      print("the img-${adverts[0].id.toString()}");
      if (adverts[0].id.toString() != id) {
        // if (adverts.length > 0) {
        // print("the img-${adverts[0].imageUrl}");
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (context) {
              return new FlashPage();
            },
            fullscreenDialog: false));
        // }
      }
    }
  }

  PokeNews _buildItemsForListView(BuildContext context, int index) {
    //print("the img-${_newsArticles[0].imageUrl}");
    return PokeNews(
        title: _newsArticles[index].name ?? "",
        time: _newsArticles[index].created_at ?? "",
        thumbnail: _newsArticles[index].imageUrl ?? "",
        blog: _newsArticles[index]);
  }

  // ListTile _buildItemsForListView(BuildContext context, int index) {
  //   return ListTile(
  //     title: _newsArticles[index].urlToImage == null
  //         ? Image.asset(Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL)
  //         : Image.network(_newsArticles[index].urlToImage),
  //     subtitle:
  //         Text(_newsArticles[index].title, style: TextStyle(fontSize: 18)),
  //   );
  // }

  // getNews() async {
  //   final http.Response response =
  //       await http.get("https://nifes.org.ng/api/mobile/posts");
  //   final Map<String, dynamic> responseData = json.decode(response.body);

  //   responseData['data'].forEach((newsDetail) {
  //     final NewsArticle news = NewsArticle(
  //         descrption: _parseHtmlString(newsDetail['body'][150]).toString(),
  //         title: newsDetail['title'],
  //         urlToImage: newsDetail['image']);
  //     setState(() {
  //       _newsArticles.add(news);
  //     });
  //   });
  // }
  // void _navigateToNextScreen(BuildContext context) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => PostDetail()));
  // }

  Future<void> _populateAnchors() async {
    final http.Response response = await http
        .get(Uri.parse("https://nifes.org.ng/api/mobile/anchor/index"));
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['anchors'].forEach((newsDetail) {
      final Anchors news = Anchors(
          description: newsDetail['description'],
          topic: newsDetail['topic'] ?? "",
          oneYear: newsDetail['one_year'] ?? "",
          bibleReading: newsDetail['bible_reading'] ?? "",
          wordOFToday: newsDetail['word_of_today'] ?? "",
          prayers: newsDetail['prayers'],
          verses: newsDetail['verses'],
          uuid: newsDetail['uuid'],
          createdAt: newsDetail['created_at'],
          year: Year.fromJson(newsDetail['year']),
          month: Year.fromJson(newsDetail['month']),
          day: Year.fromJson(newsDetail['day']));
      setState(() {
        _anchors.add(news);

        _isLoading = false;
      });
    });
  }

  Anchors getAnchor() {
    if (_anchors.length > 0) {
      for (Anchors i in _anchors) {
        var newFormat = DateFormat("dd/MMMM/yyyy");
        String updatedDt = newFormat.format(DateTime.now());
        String jsonyear = i.year.name;
        String jsonmonth = i.month.name;
        String jsonday = i.day.name;
        String alldate = "${jsonday}/${jsonmonth}/${jsonyear}";
        if (updatedDt == alldate) {
          return i;
        }
      }
    }
  }

  Anchors getBullet() {
    if (_bulletins.length > 0) {
      for (Anchors i in _bulletins) {
        var newFormat = DateFormat("dd/MMMM/yyyy");
        String updatedDt = newFormat.format(DateTime.now());
        String jsonyear = i.year.name;
        String jsonmonth = i.month.name;
        String jsonday = i.day.name;
        String alldate = "${jsonday}/${jsonmonth}/${jsonyear}";
        if (updatedDt == alldate) {
          return i;
        }
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;

    setState(() {
      showTitle = offset > appBarHeight - kToolbarHeight;
    });
  }

  String nameText = '';

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    // _scaffoldKey.currentState.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 28,
        right: 28,
        bottom: context.responsive(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Latest Posts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          InkWell(
            child: Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.indigo,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BlogHomeScreen()));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appBarHeight = context.screenSize.height * _HeaderAppBar.heightFraction;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("NIFES"),
      //   iconTheme: IconThemeData(color: Colors.red),
      // ),
      drawer: Drawer(
        child: new ListView(
          padding: new EdgeInsets.all(0.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              accountName: new Text(name ?? ""),
              accountEmail: new Text(email ?? ""),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Text(name ?? ""),
              ),
              // otherAccountsPictures: <Widget>[
              //   new CircleAvatar(
              //     backgroundColor: Colors.white,
              //     child: new Text("Pilu"),
              //   ),
              // ],
            ),
            new ListTile(
              title: new Text("Home"),
              trailing: new Icon(Icons.home),
              onTap: () {
                //  _nameRetriever();
                Navigator.of(context).pop();
              },
            ),
            // new ListTile(
            //   title: new Text("Profile"),
            //   trailing: new Icon(Icons.person),
            //   onTap: () => {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => SettingsScreen()))
            //   },
            // ),

            // new ListTile(
            //   title: new Text("Anchor"),
            //   trailing: new Icon(Icons.anchor),
            //   onTap: () => {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => ListPage(type: 1)))
            //   },
            // ),
            new ListTile(
              title: new Text("Associate and Student portal"),
              trailing: new Icon(Icons.group),
              //WebViewPage(
              // "https://nifes.org.ng/elearning", "NVM")));
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewPage(
                            "https://nifes.org.ng/login",
                            "Associate/Student portal")))
              },
            ),
            // new ListTile(
            //   title: new Text("prayer bulletin"),
            //   trailing: new Icon(Icons.book),
            //   onTap: () => {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => AnchorsPage(type: 2)))
            //   },
            // ),
            new ListTile(
              title: new Text("Updates"),
              trailing: new Icon(Icons.update),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UpdatesPage()))
              },
            ),
            new ListTile(
              title: new Text("Blog"),
              trailing: new Icon(Icons.book),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BlogHomeScreen()))
              },
            ),
            // new ListTile(
            //   title: new Text("Portal interaction"),
            //   trailing: new Icon(Icons.group),
            //   onTap: () => {},
            // ),
            new ListTile(
              title: new Text("Settings"),
              trailing: new Icon(Icons.settings),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingsScreen(name, email, phone, id)))
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("LogOut"),
              trailing: new Icon(Icons.logout),
              onTap: () => logout(),
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (_, __) => [
          _HeaderAppBar(
              height: appBarHeight,
              showTitle: showTitle,
              category: categories,
              anchors: getAnchor() ?? _anchors[0],
              bulletins: getBullet() ?? _bulletins[0]),
        ],
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                      color: Colors.purple.withOpacity(0.5),
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: _isLoading
                          ? SkeletonLoader(
                              builder: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 30,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            height: 10,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            height: 12,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              items: 1,
                              period: Duration(seconds: 2),
                              highlightColor: Colors.lightBlue[300],
                              direction: SkeletonDirection.ltr,
                            )
                          : Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.white, width: 1),
                                    right: BorderSide(
                                        color: Colors.green, width: 5),
                                    left: BorderSide(
                                        color: Colors.purple, width: 5)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        5.0, 10.0, 5.0, 5.0),
                                  ),
                                  Text("Daily Anchor",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  Text(
                                      _verses.length > 0
                                          ? _parseHtmlString(
                                              _verses[0].descrption)
                                          : "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic)),
                                  Text(
                                      _verses.length > 0
                                          ? _verses[0].urlToImage
                                          : " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ],
                              ),
                            ))
                ],
              ),
            ),
            _buildHeader(context),
            _isLoading
                ? SkeletonLoader(
                    builder: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 12,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    items: 5,
                    period: Duration(seconds: 2),
                    highlightColor: Colors.lightBlue[300],
                    direction: SkeletonDirection.ltr,
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: 5,
                    separatorBuilder: (context, index) => Divider(),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: _buildItemsForListView,
                  ),
            // ListView.builder(
            //   itemCount: 4,
            //   itemBuilder: _buildItemsForListView,
            // ),
            //   onPressed: () {
            //   _navigateToNextScreen(context);
            // },
          ],
        ),

        // ListView.builder(
        //   itemCount: _newsArticles.length,
        //   itemBuilder: _buildItemsForListView,
        // ),
      ),
      // bottomNavigationBar: BibleBottomNavigationBar(context: context),
    );
  }

  _nameRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // setState() {
    nameText = prefs.getString('token') ?? '';
    //}

    print(nameText);
  }

  void logout() async {
    // var data = {'email': ""};
    // var res = await Network().authData(data, '/logout');
    // var body = json.decode(res.body);
    // print(body);
    // if (body['success']) {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    //localStorage.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Rout.login));
    // } else {
    //   _showMsg(body['message']);
    // }
  }
}

class NewsList extends StatefulWidget {
  @override
  createState() => _HomeScreenState();
}
