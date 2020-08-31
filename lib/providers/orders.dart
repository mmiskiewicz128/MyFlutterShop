import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  String apiUrl = 'https://myshop-futterguide.firebaseio.com/orders.json';

  String getApiUrlById(String id) {
    return 'https://myshop-futterguide.firebaseio.com/orders/$id.json';
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSet() async {
    try {
      final response = await http.get(apiUrl);

      var extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((key, value) {
        OrderItem orderItem = OrderItem(
            id: key,
            amount: value['amount'],
            dateTime: DateTime.parse(value['dateTime']),
            products: (value['products'] as List<dynamic>).map((e) {
              return CartItem(
                  id: e['id'],
                  price: e['price'],
                  quantinty: e['quantinty'],
                  title: e['title']);
            }).toList());

        loadedOrders.add(orderItem);
      });

      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addOrders(List<CartItem> cartItems, double total) {
    final timeStamp = DateTime.now();

    return http
        .post(apiUrl,
            body: json.encode({
              'amount': total,
              'dateTime': timeStamp.toIso8601String(),
              'products': cartItems
                  .map((e) => {
                        'id': e.id,
                        'title': e.title,
                        'quantinty': e.quantinty,
                        'price': e.price
                      })
                  .toList()
            }))
        .then((response) {
      if (response.statusCode < 400) {
        _orders.insert(
            0,
            OrderItem(
                id: json.decode(response.body)['name'],
                amount: total,
                dateTime: timeStamp,
                products: cartItems));

        notifyListeners();
      } else {
        throw HttpException(response.reasonPhrase);
      }
    });
  }
}
