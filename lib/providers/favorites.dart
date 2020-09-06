import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Favorite {
  final String id;
  final String userId;
  final String productId;

  Favorite({this.id, this.userId, this.productId});
}

class Favorites extends ChangeNotifier {
  List<Favorite> _userFavorites = [];
  final authTokenId;
  final userId;

  String get apiUrl {
    return 'https://myshop-futterguide.firebaseio.com/favorites.json?auth=$authTokenId';
  }

  String get apiUrlByUserId {
    return 'https://myshop-futterguide.firebaseio.com/favorites.json?auth=$authTokenId&orderBy="userId"&equalTo="$userId"';
  }

  String getApiUrlById(String id) {
    return 'https://myshop-futterguide.firebaseio.com/favorites/$id.json?auth=$authTokenId';
  }

  List<Favorite> get uesrFaforites {
    return [..._userFavorites];
  }

  factory Favorites.empty() {
    return Favorites('', '', []);
  }

  Favorites(this.authTokenId, this.userId, this._userFavorites);

  Future<void> fetchAndSet() async {
    try {
      final response = await http.get(apiUrlByUserId);

      var extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null || response.statusCode >= 400) {
        throw HttpException.fromResponse(response);
      }

      final List<Favorite> loadedProducts = [];
      extractedData.forEach((key, value) {
        Favorite favorite = Favorite(
            id: key, productId: value['productId'], userId: value['userId']);

        loadedProducts.add(favorite);
      });

      _userFavorites = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> markAsFavorite(String productId) async {
    if (_userFavorites.any((element) => element.productId == productId)) {
      return Future.delayed(Duration.zero);
    }

    try {
      var response = await http.post(apiUrl,
          body: json.encode({'productId': productId, 'userId': userId}));
      if (response.statusCode < 400) {
        _userFavorites.add(Favorite(
            id: json.decode(response.body)['name'],
            productId: productId,
            userId: userId));
        notifyListeners();
      } else {
        throw HttpException.fromResponse(response);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> toggleFavorite(String productId) async {
    int index =
        _userFavorites.indexWhere((item) => item.productId == productId);
    if (index < 0) {
      try {
        var response = await http.post(apiUrl,
            body: json.encode({'productId': productId, 'userId': userId}));

        if (response.statusCode < 400) {
          _userFavorites.add(Favorite(
              id: json.decode(response.body)['name'],
              productId: productId,
              userId: userId));
          notifyListeners();
        } else {
          throw HttpException.fromResponse(response);
        }
      } catch (error) {
        throw error;
      }
    } else {
      var response = await http.delete(getApiUrlById(_userFavorites[index].id));

      if (response.statusCode < 400) {
        _userFavorites.removeAt(index);
        notifyListeners();
      } else {
        throw HttpException.fromResponse(response);
      }
    }
  }
}
