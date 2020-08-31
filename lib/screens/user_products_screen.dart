import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Products'), actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeNameCreate);
            })
      ]),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await products.fetchAndSet();
        },
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return UserProductItem(products.items[index]);
              },
              itemCount: products.items.length,
            )),
      ),
    );
  }
}
