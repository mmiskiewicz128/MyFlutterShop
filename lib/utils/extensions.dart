import 'package:shop_app/providers/favorites.dart';
import 'package:shop_app/providers/product.dart';
import 'package:intl/intl.dart';

extension ProductListExtensions on List<Product> {
  Product getProductById(String id) {
    return this.firstWhere((element) => element.id == id);
  }
}

extension ProductExtensions on Product {
  Map<String, Object> toJsonMap() {
    return {
      'title': this.title,
      'description': this.description,
      'price': this.price,
      'imageUrl': this.imageUrl
    };
  }
}

extension FavoriteExtension on Favorite {
  Map<String, Object> toJsonMap() {
    return {'userId': this.userId, 'productId': this.productId};
  }
}

extension DateTimeExtension on DateTime {
  String getFormatedDateTime() {
    return DateFormat('dd.MM.yyyy HH:mm').format(this);
  }
}
