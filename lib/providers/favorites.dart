import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Favorite {
  final String id;
  final String userId;
  final String productId;

  Favorite({this.id, this.userId, this.productId});
}

class Favorites extends ChangeNotifier {
  List<Favorite> _userFavorites = [];
  String userIdMock = 'xxx';

  String apiUrl = 'https://myshop-futterguide.firebaseio.com/favorites.json';

  String getApiUrlById(String id) {
    return 'https://myshop-futterguide.firebaseio.com/favorites/$id.json';
  }

  List<Favorite> get uesrFaforites {
    return [..._userFavorites];
  }

  Future<void> fetchAndSet() async {
    try {
      final response = await http.get(apiUrl);

      var extractedData = json.decode(response.body) as Map<String, dynamic>;

   if (extractedData == null || response.statusCode >= 400) {
        return;
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

  Future<void> markAsFavorite(String productId) {
    if (_userFavorites.any((element) => element.productId == productId)) {
      return Future.delayed(Duration.zero);
    }
    return http
        .post(apiUrl,
            body: json.encode({'productId': productId, 'userId': userIdMock}))
        .catchError((error) {
      print(error);
    }).then((response) {
      if (response.statusCode < 400) {
        _userFavorites.add(Favorite(
            id: json.decode(response.body)['name'],
            productId: productId,
            userId: userIdMock));
        notifyListeners();
      }
    });
  }

  Future<void> toggleFavorite(String productId) {
    int index =
        _userFavorites.indexWhere((item) => item.productId == productId);
    if (index < 0) {
      return http
          .post(apiUrl,
              body: json.encode({'productId': productId, 'userId': userIdMock}))
          .catchError((error) {
        print(error);
      }).then((response) {
        if (response.statusCode < 400) {
          _userFavorites.add(Favorite(
              id: json.decode(response.body)['name'],
              productId: productId,
              userId: userIdMock));
          notifyListeners();
        }
      });
    } else {
      return http
          .delete(getApiUrlById(_userFavorites[index].id))
          .catchError((error) {
        print(error);
      }).then((response) {
        if (response.statusCode < 400) {
          _userFavorites.removeAt(index);
          notifyListeners();
        }
      });
    }
  }
}
