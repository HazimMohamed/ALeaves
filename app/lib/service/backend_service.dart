import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class BackendService {
  static const backendUrl = '127.0.0.1:5000';
  static BackendService? instance;

  BackendService._internal();

  factory BackendService() {
    if (instance == null) {
      instance = BackendService._internal();
      return instance!;
    }
    return instance!;
  }

  Future<dynamic> post(String path, Object data) async {
    Response resp = await http.post(Uri.http(backendUrl, path),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    return jsonDecode(resp.body);
  }
}
