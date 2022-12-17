import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/utils/news.dart';

class GetDataProvider with ChangeNotifier {
  List<news> responseData = List<news>.empty(growable: true);
  Box? box;
  bool isLoading = false;

  getMyData() async {
    isLoading = true;
    responseData = await getAllData();
    isLoading = false;
    notifyListeners();
  }

  Future openBox() async {
    var dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

  Future<List<news>> getAllData() async {
    if (kIsWeb) {
    } else {
      await openBox();
    }
    try {
      final url =
          "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f8d23c86fb5d4c90aa5c570fd18f370d";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final items = json.decode(response.body);
        if (kIsWeb) {
          items["articles"].forEach((v) {
            responseData.add(news.fromJson(v));
          });
        } else
          await putData(items["articles"]);
      } else {
        print("Not Connected to API");
      }
    } catch (e) {
      log(e.toString());
    }
    if (kIsWeb) {
    } else {
      var mymap = box?.toMap().values.toList();
      if (mymap != null && !(mymap.isEmpty)) {
        mymap.forEach((v) {
          responseData.add(news.fromJson(v));
        });
      }
    }
    notifyListeners();
    return responseData;
  }

  putData(data) async {
    await box?.clear();
    for (var d in data) {
      box?.add(d);
      // print(d);
    }
  }
}
