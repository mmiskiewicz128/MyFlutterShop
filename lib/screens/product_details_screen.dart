import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/favorites.dart';
import 'package:shop_app/widgets/favorite_animated_icon.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static final String routeName = '/product-details';

  ProductDetailsScreen();

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final products = Provider.of<Products>(context, listen: false);
    final product =
        products.items.firstWhere((element) => element.id == productId);

    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: FavoriteAnimatedIcon(
                  iconSize: 150,
                  child: Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  productId: product.id),
            ),

            // SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: Colors.black87, boxShadow: [
                BoxShadow(
                    offset: Offset(0.0, 1.0),
                    color: Colors.black45,
                    blurRadius: 6.0)
              ]),
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.shopping_cart,
                            size: 30, color: Theme.of(context).accentColor),
                        onPressed: () {
                          cart.addItem(
                              product.id, product.price, product.title);
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Item Added'),
                            duration: Duration(seconds: 1),
                            action: SnackBarAction(
                                onPressed: () {
                                  cart.removeSingleItem(product.id);
                                },
                                label: 'Undo'),
                          ));
                        },
                      ),
                    ),
                    Consumer<Favorites>(
                      builder: (context, favorites, _) => IconButton(
                        icon: Icon(
                            favorites.uesrFaforites.any((element) =>
                                    element.productId == product.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 30,
                            color: Theme.of(context).accentColor),
                        onPressed: () {
                          favorites.toggleFavorite(product.id);
                        },
                      ),
                    ),
                    Spacer(),
                    Text('\$${product.price}',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                child: Text(product.description))
          ],
        ),
      ),
    );
  }
}
