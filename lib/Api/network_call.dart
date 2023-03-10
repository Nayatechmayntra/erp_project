import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource(
      {required this.url, required this.parse, Map<String, String>? headers});
}

late SharedPreferences pref;
String? Token;

class Webservice {
  var tag = "Webservice----";

  Future<T> loadPostWithoutParam<T>(Resource<T> resource) async {
    //final response = await http.post(resource.url);
    final response = await http.post(Uri.parse(resource.url));
    print("api url............" + resource.url);
    print("response............" + response.toString());

    if (response.statusCode == true) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }
  Future<T> loadPost<T>(Resource<T> resource, Map body) async {
    final response = await http.post(Uri.parse(resource.url), body: body);
    // final response = await http.http.MultipartRequest("POST", postUri);
    print("response........................." + response.toString());
    print("response........................." + response.statusCode.toString());

    if (response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  // Future<T> loadMultiPost<T>(Resource<T> resource,Map body) async {
  //   final response = await http.MultipartRequest("POST",Uri.parse(resource.url),body:body);
  //   // final response = await http.http.MultipartRequest("POST", postUri);
  //   print("response........................." + response.toString());
  //   //print("response........................." + response..toString());
  //   //
  //   // if (response.statusCode == 200) {
  //   //   return resource.parse(response);
  //   // } else {
  //   //   throw Exception('Failed to load data!');
  //   // }
  // }


  Future<T> loadPostWithToken<T>(
      Resource<T> resource, Map body, String token) async {
    final response =
    await http.post(Uri.parse(resource.url), body: body, headers: {
      'Authorization': 'Bearer $token',

      /* HttpHeaders.authorizationHeader:
          "eyJhdWQiOiIxIiwianRpIjoiOGE0NjFjZWMyYmNmYzBlNGU1ZjJmZjc0YzYyZTBlZTY1MzQxOWQyYjFmMDRiYmNmODU5YzE1NzFiMDkxYWQ5NjYzMjkyMjlkM2M3ODI5OGQiLCJpYXQiOjE2Njc4MTk4OTIuODU1ODA2LCJuYmYiOjE2Njc4MTk4OTIuODU1ODEsImV4cCI6MTY5OTM1NTg5Mi44NTAyNjYsInN1YiI6IjE5Iiwic2NvcGVzIjpbXX0.CChFwkKtSrlAt2Y9MY0oFQPuQjzGYxoc2Zp21qJvWNT24fmBfZk8QPhnOgk_h8gMYElYeSaOrLYJ4vXMmA2bTWi1aOGBZ2LhXZ4EYjssK3QDEcW9xuZcKnZQwG7PMVnIJ_zDWl4XgzR3b98A-fjpCZYTY2q8mfB-3utG2q5RdhmzkUqsNWBQ4xVsBYrDJgKfS4QCueSA8ArV-XhXwC355G-me58iTTZtHYnG3ZNmjl7J7gMiRHYYZBcp84HIQPhCT9LNaOk7VMKTEtDLOLSyABPkx-rqVYBWlneUUWuKalMpZme8DmDwL8PgUFTHahefVpYjHATl7Ol4h0qvWggkfca6l3iJ5mDJhgYhJ56lSSumwEn7FNdinTvNPQewpgHZCcj7-w48Vl0kXRgRcQ_tkW1LdQuhMot-q7OD0tJFM0GV8fYnSEDD9xNz7ownmvq5lPz5zmYPIfIndhMO8XVNJGtP8BvH0N6IFbRWXRcT0qDgLz8TkYcEHQ5crt-6sL3s1o5v9qm2epXEn1CJy61bCaF-7rYFFuEXkdnRVSv0DMaleWf2ojkI9yag8kK65Wb4lZoxy2GI4w1DhODXTl5rFzHdStW58OhLc14cNxtcv6Tf7Gf-J8MoFqTydpsRaDJ4LWRY3AKQuk6sMDebEbipGkqHH1llgTsK6cy-xLVQm0U",
  */
    });
    // final response = await http.http.MultipartRequest("POST", postUri);
    print("response........................." + response.toString());
    print("response........................." + response.statusCode.toString());

    if (response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<T> loadGET<T>(Resource<T> resource) async {
    final response = await http.get(Uri.parse(resource.url));
    print("response........................." + response.toString());

    if (response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  String? method;

  Future<T> loadGetWithToken<T>(Resource<T> resource, String token) async {
    final response = await http.get(Uri.parse(resource.url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',

      /* HttpHeaders.authorizationHeader:
          "eyJhdWQiOiIxIiwianRpIjoiOGE0NjFjZWMyYmNmYzBlNGU1ZjJmZjc0YzYyZTBlZTY1MzQxOWQyYjFmMDRiYmNmODU5YzE1NzFiMDkxYWQ5NjYzMjkyMjlkM2M3ODI5OGQiLCJpYXQiOjE2Njc4MTk4OTIuODU1ODA2LCJuYmYiOjE2Njc4MTk4OTIuODU1ODEsImV4cCI6MTY5OTM1NTg5Mi44NTAyNjYsInN1YiI6IjE5Iiwic2NvcGVzIjpbXX0.CChFwkKtSrlAt2Y9MY0oFQPuQjzGYxoc2Zp21qJvWNT24fmBfZk8QPhnOgk_h8gMYElYeSaOrLYJ4vXMmA2bTWi1aOGBZ2LhXZ4EYjssK3QDEcW9xuZcKnZQwG7PMVnIJ_zDWl4XgzR3b98A-fjpCZYTY2q8mfB-3utG2q5RdhmzkUqsNWBQ4xVsBYrDJgKfS4QCueSA8ArV-XhXwC355G-me58iTTZtHYnG3ZNmjl7J7gMiRHYYZBcp84HIQPhCT9LNaOk7VMKTEtDLOLSyABPkx-rqVYBWlneUUWuKalMpZme8DmDwL8PgUFTHahefVpYjHATl7Ol4h0qvWggkfca6l3iJ5mDJhgYhJ56lSSumwEn7FNdinTvNPQewpgHZCcj7-w48Vl0kXRgRcQ_tkW1LdQuhMot-q7OD0tJFM0GV8fYnSEDD9xNz7ownmvq5lPz5zmYPIfIndhMO8XVNJGtP8BvH0N6IFbRWXRcT0qDgLz8TkYcEHQ5crt-6sL3s1o5v9qm2epXEn1CJy61bCaF-7rYFFuEXkdnRVSv0DMaleWf2ojkI9yag8kK65Wb4lZoxy2GI4w1DhODXTl5rFzHdStW58OhLc14cNxtcv6Tf7Gf-J8MoFqTydpsRaDJ4LWRY3AKQuk6sMDebEbipGkqHH1llgTsK6cy-xLVQm0U",
  */
    });
    print('Token Fatch : ${token}');

    print("response........................." + response.toString());

    if (response.statusCode == 200) {
      print(response.body);
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<T> loadLocationGET<T>(Resource<T> resource) async {
    final response = await http.get(Uri.parse(resource.url));
    print("response........................." + response.toString());

    if (response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }
}


