import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final CartItem cartItem;
  final String productId;

  CartListItem(this.cartItem, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want remove the item from the cart?'),
                  actions: [
                    FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }),
                    FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        })
                  ]);
            });
      },
      key: ValueKey(cartItem.id),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, size: 30, color: Colors.white),
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),
      child: Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(
                            child: Text(
                                '\$${cartItem.price.toStringAsFixed(2)}')))),
                title: Text(cartItem.title),
                subtitle: Text(
                    '\$${(cartItem.price * cartItem.quantinty).toStringAsFixed(2)}'),
                trailing: Text(cartItem.quantinty.toString()),
              ))),
    );
  }
}
