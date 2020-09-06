import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/favorites.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) {
          return Auth();
        }),
        ChangeNotifierProvider(create: (ctx) {
          return Products();
        }),
        ChangeNotifierProvider(create: (ctx) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (ctx) {
          return Orders();
        }),
        ChangeNotifierProvider(create: (ctx) {
          return Favorites();
        }),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.redAccent,
            fontFamily: 'Lato'),
        home: AuthScreen(), //ProductOverviewScreen(),
        routes: {
          ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeNameCreate: (ctx) =>
              EditProductScreen(isEditProductMode: false),
          EditProductScreen.routeNameEdit: (ctx) =>
              EditProductScreen(isEditProductMode: true),
          AuthScreen.routeName: (ctx) => AuthScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
