import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/favorites.dart';
import 'package:shop_app/widgets/favorite_animated_icon.dart';
import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatefulWidget {
  final isFavoriteScreen;

  ProductItem({this.isFavoriteScreen = false});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: true);
    final Favorites favorites = Provider.of<Favorites>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);

    return FavoriteAnimatedIcon(
      productId: product.id,
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
      },
      child: Card(
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: GridTile(
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
              footer: GridTileBar(
                title: Text(product.title,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis),
                backgroundColor: Colors.black87,
                trailing: IconButton(
                  icon: Icon(Icons.shopping_cart,
                      color: Theme.of(context).accentColor),
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: [
                          Text('Item Added to cart'),
                          SizedBox(width: 10),
                          Icon(Icons.shopping_cart,
                              color: Theme.of(context).accentColor)
                        ],
                      ),
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
            ),
          ),
          if (widget.isFavoriteScreen)
            Positioned(
                right: -10,
                top: -10,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    favorites.toggleFavorite(product.id);
                  },
                )),
        ]),
      ),
    );
  }
}
