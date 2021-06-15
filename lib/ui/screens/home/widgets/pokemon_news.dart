part of '../home.dart';

//List<NewsArticle> _newsArticles = List<NewsArticle>();

//final List<Photo> photos;
final List<NewsArticle> _newsArticles = [];

class _PokemonNews extends StatelessWidget {
  _PokemonNews() {
    // TODO: do an http request
    getNews();
  }

  // _PokemonNews(List<NewsArticle> newsArticles);
  //this._newsArticles = new
  PokeNews _buildItemsForListView(BuildContext context, int index) {
    return PokeNews(title: _newsArticles[index].title, time: '15 May 2019', thumbnail: _newsArticles[index].urlToImage);

    // ListTile(
    //   title: _newsArticles[index].urlToImage == null
    //       ? Image.asset(Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL)
    //       : Image.network(_newsArticles[index].urlToImage),
    //   subtitle:
    //       Text(_newsArticles[index].title, style: TextStyle(fontSize: 18)),
    // );
  }

  getNews() async {
    final http.Response response = await http.get(Uri.parse("https://nifes.org.ng/api/mobile/posts"));
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['data'].forEach((newsDetail) {
      final NewsArticle news = NewsArticle(descrption: _parseHtmlString(newsDetail['body'][150]).toString(), title: newsDetail['title'], urlToImage: newsDetail['image']);
      // setState(() {
      _newsArticles.add(news);
      // });
    });
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
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
          Text(
            'View All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("newss");
    print(_newsArticles);
    return ListView(
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
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white, width: 1), right: BorderSide(color: Colors.green, width: 5), left: BorderSide(color: Colors.purple, width: 5)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                        ),
                        Text("Daily Bible Verse", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        Text("But while they were on their way to buy the oil, the bridegroom arrived. The virgins who were ready went in with him to the wedding banquet. And the door was shut", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontStyle: FontStyle.italic)),
                        Text("MATTHEW 25:1-13", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ))
            ],
          ),
        ),
        _buildHeader(context),
        ListView.separated(
          shrinkWrap: true,
          itemCount: 3,
          separatorBuilder: (context, index) => Divider(),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PokeNews(
              title: _newsArticles[index].title,
              time: '15 May 2019',
              thumbnail: _newsArticles[index].urlToImage,
            );
          },
        ),
        // ListView.builder(
        //   itemCount: 4,
        //   itemBuilder: _buildItemsForListView,
        // ),
      ],
    );
  }
}

// class NewsList extends StatefulWidget {
//   @override
//   createState() => _PokemonNews();
// }
