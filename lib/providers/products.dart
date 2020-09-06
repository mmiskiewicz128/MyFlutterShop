import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';
import 'product.dart';
import '../utils/extensions.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final authTokenId;

  String get apiUrl {
      return 'https://myshop-futterguide.firebaseio.com/products.json?auth=$authTokenId';
  }

  String apiUrlById(String id) {
    return 'https://myshop-futterguide.firebaseio.com/products/$id.json?auth=$authTokenId';
  }

  List<Product> get items {
    // zwracam kopie listy. nie przekazuje referencji do _items
    return [..._items];
  }

  Products(this.authTokenId, this._items);

  Future<void> addProduct(Product value) {
    return http
        .post(apiUrl, body: json.encode(value.toJsonMap()))
        .catchError((error) {
      print(error.toString());
    }).then((response) {
      if (response.statusCode < 400) {
        final product = Product(
            id: json.decode(response.body)['name'],
            title: value.title,
            description: value.description,
            price: value.price,
            imageUrl: value.imageUrl);

        _items.add(product);
        notifyListeners();
      } else {
        throw HttpException(response.reasonPhrase);
      }
      // firebase zapisuje uniqueid w name
    });
    // coś jak notifypropertychanged
  }

  Future<void> fetchAndSet() async {
    try {
      final response = await http.get(apiUrl);

      var extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null || response.statusCode >= 400) {
          throw HttpException.fromResponse(response);
      }

      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        Product product = Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl']);

        loadedProducts.add(product);
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // Nie ma różnicy w działaniu tych dwóch metod.
  // Async Await jest dodany automatycznie do metod Future
  Future<void> addProductAlternativeWay(Product value) async {
    try {
      final response =
          await http.post(apiUrl, body: json.encode(value.toJsonMap()));

      final product = Product(
          id: json.decode(response.body)['name'],
          title: value.title,
          description: value.description,
          price: value.price,
          imageUrl: value.imageUrl);

      _items.add(product);
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> removeProduct(String productId) {
    return http.delete(apiUrlById(productId)).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product');
      } else {
        _items.removeWhere((element) => element.id == productId);
        notifyListeners();
      }
    });
  }

  Future<void> updateProduct(Product value) {
    return http
        .patch(apiUrlById(value.id), body: json.encode(value.toJsonMap()))
        .then((response) {
      _items.removeWhere((element) => element.id == value.id);

      final product = Product(
          id: json.decode(response.body)['name'],
          title: value.title,
          description: value.description,
          price: value.price,
          imageUrl: value.imageUrl);
      _items.add(product);
      notifyListeners();
    });
  }
}
