import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_list_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<Orders>(context, listen: false).fetchAndSet().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return OrderListItem(ordersData.orders[index]);
              },
              itemCount: ordersData.orders.length,
            ),
    );
  }
}
