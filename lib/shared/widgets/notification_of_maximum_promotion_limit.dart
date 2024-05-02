
import 'package:flutter/material.dart';


class NotificationMaximumPromotionlimit extends StatelessWidget {
  final VoidCallback onClose;

  NotificationMaximumPromotionlimit({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 75,
        width: double.infinity,
        color: Colors.grey[400], // Fondo gris oscuro
        child: Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Has alcanzado la cantidad máxima de compra para esta promoción",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
