import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/utils/utils.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final showFavoritesOnly;

  const ProductsGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final products = showFavoritesOnly
        ? ProviderUtils.getFavoriteProductList(context)
        : ProviderUtils.getProductList(context);

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
            child: ProductItem(isFavoriteScreen: showFavoritesOnly ?? false),
            key: ValueKey(products[index].id),
            value: products[index],
          );
        });
  }
}
