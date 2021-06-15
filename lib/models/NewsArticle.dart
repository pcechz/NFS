import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/services/webservice.dart';
import 'package:app/utils/constants.dart';
// import 'package:app/utils/constants.dart';

class NewsArticle {
  final String title;
  final String descrption;
  final String urlToImage;
  final String time;

  NewsArticle({this.title, this.descrption, this.urlToImage, this.time});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    // if (json['data'] != null) {
    // data = json['data'];
    Map<String, dynamic> theData = json;
    print("this image${theData['image'].substring(22)}");
    return NewsArticle(
        title: theData['title'],
        descrption: theData['body'],
        urlToImage: theData['image'] ??
            Constants
                .NEWS_PLACEHOLDER_IMAGE_ASSET_URL, // theData['image'] ?? Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
        time: theData['created_at']);
    //}
  }

  static Resource<List<NewsArticle>> get all {
    return Resource(
        url: Constants.HEADLINE_NEWS_URL,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result['data'];
          print("$list");
          return list.map((model) => NewsArticle.fromJson(model)).toList();
        });
  }
}
