import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(title: Text('MyShop'), automaticallyImplyLeading: false),
        Divider(),
        ListTile(
          leading: Icon(Icons.shopping_basket),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          },
        ),
        Consumer<Auth>(builder: (ctx, auth, _) {
          return auth.isAdmin ? Column(children: [
            Divider(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Menage Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
            )
          ]) : SizedBox.shrink();
        }),
        Divider(),
        Consumer<Auth>(builder: (ctx, auth, _) {
          return ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            auth.logout();
          },
        );

        })
        
      ],
    ));
  }
}
