import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/favorites.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptions { favorite, all }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/products';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoritesOnly = false;
  bool _isInit = false;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Favorites>(context, listen: false).fetchAndSet();
      Provider.of<Products>(context, listen: false)
          .fetchAndSet()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.favorite) {
                      _showFavoritesOnly = true;
                    } else {
                      _showFavoritesOnly = false;
                    }
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                          child: Text('Only Favorites'),
                          value: FilterOptions.favorite),
                      PopupMenuItem(
                          child: Text('Show All'), value: FilterOptions.all)
                    ]),
            Consumer<Cart>(
              builder: (context, cart, _) => Badge(
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                  value: cart.itemCount.toString()),
            ),
            SizedBox(width: 20)
          ],
        ),
        drawer: AppDrawer(),
        drawerEdgeDragWidth: 200,
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ProductsGrid(_showFavoritesOnly));
  }
}
