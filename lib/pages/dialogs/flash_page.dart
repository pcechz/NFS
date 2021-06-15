import 'package:app/models/Advert.dart';
import 'package:app/services/webservice.dart';
import 'package:flutter/material.dart';
import 'package:meet_network_image/meet_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashPage extends StatefulWidget {
  @override
  FlashPageState createState() => new FlashPageState();
}

class FlashPageState extends State<FlashPage> {
  List<Advert> adverts = List<Advert>();

  @override
  void initState() {
    super.initState();
    _populateNewsArticles();
  }

  void _populateNewsArticles() async {
    await Webservice().load(Advert.all).then((newsArticles) => {
          setState(() => {adverts = newsArticles})
        });
    print("the img-${adverts[0].urlToImage}");
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('ad_id', adverts[0].id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.close),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: new Container(
        child: MeetNetworkImage(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
          //color: Colors.purple,
          colorBlendMode: BlendMode.difference,
          imageUrl: adverts[0].urlToImage,
          loadingBuilder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
          errorBuilder: (context, e) => Center(
            child: Text('Error appear!'),
          ),
        ),
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(

        //   image: DecorationImage(
        //     alignment: Alignment.center,
        //     image: NetworkImage(adverts[0].urlToImage),
        //     fit: BoxFit.fill,
        //     // fit: BoxFit.fitWidth also can use fit: BoxFit.fitHeight
        //   ),
        // ),
      ),
    );
  }
}
