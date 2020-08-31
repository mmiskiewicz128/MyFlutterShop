import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ListTile(
              leading:
                  CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
              title: Text(product.title),
              subtitle: Text(product.description,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Container(
                  alignment: Alignment.centerRight,
                  width: 100,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                        icon: Icon(Icons.edit,
                            color: Theme.of(context).accentColor),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              EditProductScreen.routeNameEdit,
                              arguments: product);
                        }),
                    IconButton(
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).accentColor),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text('Are you sure?'),
                                  content:
                                      Text('Do you want remove the product?'),
                                  actions: [
                                    FlatButton(
                                        child: Text('Yes'),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        }),
                                    FlatButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        })
                                  ],
                                );
                              }).then((value) {
                            if (value) {
                              Provider.of<Products>(context, listen: false)
                                  .removeProduct(product.id);
                            }
                          });
                        })
                  ]))),
        ));
  }
}
