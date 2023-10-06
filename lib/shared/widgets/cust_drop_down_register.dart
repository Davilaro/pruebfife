import 'package:flutter/material.dart';

class CustomDropdownReg extends StatelessWidget {
  final String hintText;
  final TextStyle hintStyle;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final IconData icon;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final void Function(String?) onChanged;

  CustomDropdownReg({
    required this.hintText,
    this.hintStyle = const TextStyle(),
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.black,
    this.borderRadius = 35,
    this.icon = Icons.arrow_drop_down,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 1.0,
                  offset: Offset(0, 3),
                ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        style: TextStyle(color: textColor, fontSize: 15),
        items: items,
        decoration: InputDecoration(
          fillColor: textColor,
          hintText: hintText,
          hintStyle: hintStyle,
          icon: Icon(
            icon,
            color: textColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}