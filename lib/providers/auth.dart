import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirtDate;
  String _userId;
  bool isAdmin;
  Timer _autoLogoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expirtDate != null &&
        _expirtDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  final _singUpUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBzio-gp6Ot0tsHnMOXHlDc4l_l3KV5UEE";
  final _singInUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBzio-gp6Ot0tsHnMOXHlDc4l_l3KV5UEE";

  String get _getAdmonUsersUrl {
    return "https://myshop-futterguide.firebaseio.com/adminUsers.json?auth=$token";
  }

  Future<void> _authenticate(String email, String password, String url) async {
    var jsonEncode = json.encode({
      "email": email.trim(),
      "password": password,
      "returnSecureToken": true
    });
    try {
      final response = await http.post(url, body: jsonEncode);
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400 || responseData['error'] != null) {
        throw HttpException.fromResponse(response);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expirtDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      await _fetchIsAdmin();
      _autoLogout();
      notifyListeners();

      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expirtDate.toIso8601String()
      });
      preferences.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }

    final userData =
        json.decode(preferences.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _expirtDate = expiryDate;
    await _fetchIsAdmin();
    notifyListeners();
    return true;
  }

  // zwracay wywoływane taski w ten sposób
  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, _singInUrl);
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, _singUpUrl);
  }

  Future<void> _fetchIsAdmin() async {
    var response = await http.get(_getAdmonUsersUrl);

    var extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null || response.statusCode >= 400) {
      throw HttpException.fromResponse(response);
    }

    final List<String> admins = [];
    extractedData.forEach((key, value) {
      admins.add(value);
    });

    isAdmin = admins.contains(userId);

    if (isAdmin) {
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    _expirtDate = null;
    _userId = null;
    isAdmin = false;
    _autoLogoutTimer?.cancel();
    _autoLogoutTimer = null;
    notifyListeners();
  }

  void _autoLogout() {
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer.cancel();
    }

    final logoutTime = _expirtDate.difference(DateTime.now()).inSeconds;
    _autoLogoutTimer = Timer(Duration(seconds: logoutTime), logout);
  }
}
