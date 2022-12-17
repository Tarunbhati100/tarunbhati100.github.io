import 'package:flutter/material.dart';

class news {
  String ?headline;
  String ?site;
  String ?date;
  String ?url;
  String ?description;
  news(
      {this.date = "",
      this.headline = "",
      this.site = "",
      this.url = "",
      this.description = ""});

  news.fromJson(Map<String, dynamic> json) {
    headline = json['title'];
    site = json['source']['name'];
    date = json['publishedAt'];
    url = json['urlToImage'];
    description = json['description'];
  }
}
