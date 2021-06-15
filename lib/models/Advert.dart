import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/services/webservice.dart';
import 'package:app/utils/constants.dart';
// import 'package:app/utils/constants.dart';

class Advert {
  final int id;
  final String title;
  final String slug;
  final String descrption;
  final String urlToImage;
  final String time;

  Advert(
      {this.id,
      this.title,
      this.slug,
      this.descrption,
      this.urlToImage,
      this.time});

  factory Advert.fromJson(Map<String, dynamic> json) {
    // if (json['data'] != null) {
    // data = json['data'];
    Map<String, dynamic> theData = json;
    print(theData['image'].substring(19));
    return Advert(
        id: theData['id'],
        title: theData['title'],
        slug: theData['slug'],
        descrption: theData['body'],
        urlToImage: theData['image'] ??
            Constants
                .NEWS_PLACEHOLDER_IMAGE_ASSET_URL, //'https://nifes.org.ng/' + theData['image'].substring(19) ??
        //  Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
        time: theData['created_at']);
    //}
  }

  static Resource<List<Advert>> get all {
    return Resource(
        url: Constants.HEADLINE_ADVERT_URL,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result['data'];
          print("$list");
          return list.map((model) => Advert.fromJson(model)).toList();
        });
  }
}
