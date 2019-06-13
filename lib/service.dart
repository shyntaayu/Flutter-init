import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'models/post.dart';

class Services {
  static const String url = "https://jsonplaceholder.typicode.com/photos";

Response response;
  static Future<List<Classes>> getClasses() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Classes> list = parseClasses(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Classes> parseClasses(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Classes>((json) => Classes.fromJson(json)).toList();
  }
}