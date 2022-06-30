import 'package:emart/src/utils/widget_styles.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({
    Key? key,
    this.body,
    this.color = Colors.white,
    this.borderRadius = WidgetStyles.cardRadius,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);
  final Widget? body;
  Color color = Colors.white;
  double borderRadius;
  EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: WidgetStyles.cardElevation,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WidgetStyles.cardRadius)),
      child: Padding(
        padding: padding,
        child: body,
      ),
    );
  }
}
