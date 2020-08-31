import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/favorites.dart';

class FavoriteAnimatedIcon extends StatefulWidget {
  final double iconSize;
  final Widget child;
  final String productId;
  final Function onTap;
  FavoriteAnimatedIcon(
      {@required this.child,
      @required this.productId,
      this.iconSize = 80,
      this.onTap});

  @override
  _FavoriteAnimatedIconState createState() => _FavoriteAnimatedIconState();
}

class _FavoriteAnimatedIconState extends State<FavoriteAnimatedIcon> {
  bool _favoriteVisibility = false;

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<Favorites>(context);
    return GestureDetector(
      child: Stack(children: [
        Center(child: this.widget.child),
        Center(
            child: AnimatedOpacity(
          duration: Duration(milliseconds: 220),
          opacity: _favoriteVisibility ? 1.0 : 0.0,
          child: Icon(Icons.favorite,
              size: widget.iconSize, color: Theme.of(context).accentColor),
        ))
      ]),
      onTap: widget.onTap,
      onDoubleTap: () {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Text('Added to favorites'),
              SizedBox(width: 10),
              Icon(Icons.favorite, color: Theme.of(context).accentColor),
              
            ],
          ),
          
          duration: Duration(seconds: 1),

        ));

        favorites.markAsFavorite(widget.productId).then((value) {
          setState(() {
            _favoriteVisibility = true;
          });
        }).then((value) {
          Future.delayed(Duration(milliseconds: 1000)).then((value) {
            setState(() {
              favorites.markAsFavorite(widget.productId).then((value) {
                setState(() {
                  _favoriteVisibility = true;
                });
              }).then((value) {
                Future.delayed(Duration(milliseconds: 1000)).then((value) {
                  setState(() {
                    _favoriteVisibility = false;
                  });
                });
              });
            });
          });
        });
      },
    );
  }
}
