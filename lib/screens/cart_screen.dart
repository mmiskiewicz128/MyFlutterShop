import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../providers/cart.dart';
import '../widgets/cart_list_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  _isLoading
                      ? Container(width: 100, child: Center(child: CircularProgressIndicator()))
                      : Container( width: 100,
                        child: FlatButton(
                            child: Text('Order now'),
                            onPressed: cart.items.values.length == 0
                                ? null
                                : () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    Provider.of<Orders>(context, listen: false)
                                        .addOrders(cart.items.values.toList(),
                                            cart.totalAmount)
                                        .then((_) {
                                      cart.clear();
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    });
                                  },
                            textColor: Theme.of(context).primaryColor,
                          ),
                      )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return CartListItem(cart.items.values.toList()[index],
                        cart.items.keys.toList()[index]);
                  },
                  itemCount: cart.itemCount))
        ],
      ),
    );
  }
}
