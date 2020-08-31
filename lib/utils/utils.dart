import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/favorites.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class ProviderUtils {
  static Products getProductsData(BuildContext context, {bool listen = true}) {
    return Provider.of<Products>(context);
  }

  static List<Product> getProductList(BuildContext context,
      {bool listen = true}) {
    // listen oznacza czy widget ma nasłuchiwać zmian
    // jeśli tak przeładuje się po każdej zmianie w providerze
    // jeśli nie pozostaje bez mian
    return Provider.of<Products>(context, listen: listen)?.items ??
        List<Product>();
  }

  static List<Product> getFavoriteProductList(BuildContext context,
      {bool listen = true}) {
    var favoriets =
        Provider.of<Favorites>(context, listen: listen).uesrFaforites;

    return Provider.of<Products>(context, listen: listen).items.where(
        (item) => favoriets.any((favorite) => favorite.productId == item.id)).toList();
  }
}
