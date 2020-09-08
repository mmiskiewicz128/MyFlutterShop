import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart';
import '../utils/extensions.dart';

class OrderListItem extends StatefulWidget {
  final OrderItem orderItem;

  OrderListItem(this.orderItem);

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(widget.orderItem.dateTime.getFormatedDateTime()),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          //  if (_isExpanded)
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            constraints: BoxConstraints(
                maxHeight: _isExpanded
                    ? min(widget.orderItem.products.length * 20.0 + 50, 180)
                    : 0,
                minHeight: _isExpanded
                    ? min(widget.orderItem.products.length * 20.0 + 50, 180)
                    : 0),
            curve: Curves.easeInSine,
            child: Container(
              //height: min(widget.orderItem.products.length * 20.0 + 50, 180),
              child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            child: Text(widget.orderItem.products[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                          Text('${widget.orderItem.products[index].quantinty}x',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18)),
                          Text(
                              '\$${widget.orderItem.products[index].price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 18))
                        ],
                      ),
                    );
                  },
                  itemCount: widget.orderItem.products.length),
            ),
          )
        ],
      ),
    );
  }
}
