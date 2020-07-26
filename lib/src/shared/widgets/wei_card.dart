import 'package:flutter/material.dart';

/// This is the default application card
class WeiCard extends StatelessWidget {
  const WeiCard({
    Key key, 
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    this.height,
    this.constraints,
    this.color,
    @required this.child
  }) : super(key: key);

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  final double height;

  final BoxConstraints constraints;

  final Color color;

  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      constraints: constraints,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: color ?? Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 30.0,// has the effect of extending the shadow
            offset: const Offset(
              0.0, // horizontal
              10.0, // vertical
            ),
          )
        ],
      ),
      margin: margin,
      child: child,
    );
  }
}