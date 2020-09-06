import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirtDate;
  String _userId;

  final _singUpUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBzio-gp6Ot0tsHnMOXHlDc4l_l3KV5UEE";
  final _singInUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBzio-gp6Ot0tsHnMOXHlDc4l_l3KV5UEE";

  Future<void> _authenticate(String email, String password, String url) async {
    var jsonEncode = json.encode({
      "email": email.trim(),
      "password": password,
      "returnSecureToken": true
    });
    try {
      final response = await http.post(url, body: jsonEncode);
      if (response.statusCode >= 400) {
        final responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          throw HttpException.fromResponse(response);
        }
      }

      print(response);
    } catch (error) {
       throw error;
    }
  }

  // zwracay wywoływane taski w ten sposób
  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, _singInUrl);
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, _singUpUrl);
  }
}
