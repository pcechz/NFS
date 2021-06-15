import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/services/webservice.dart';
import 'package:app/utils/constants.dart';
// import 'package:app/utils/constants.dart';

class Verses {
  final String title;
  final String slug;
  final String descrption;
  final String urlToImage;
  final String time;

  Verses({this.title, this.slug, this.descrption, this.urlToImage, this.time});

  factory Verses.fromJson(Map<String, dynamic> json) {
    // if (json['data'] != null) {
    // data = json['data'];
    Map<String, dynamic> theData = json;
    // print(theData['image'].substring(19));
    return Verses(
        title: theData['title'],
        slug: theData['slug'],
        descrption: theData['body'],
        urlToImage: theData['verse'],
        time: theData['created_at']);
    //}
  }

  static Resource<List<Verses>> get all {
    return Resource(
        url: Constants.HEADLINE_VERSE_URL,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result['data'];
          // print("the listee $list");
          return list.map((model) => Verses.fromJson(model)).toList();
        });
  }
}
