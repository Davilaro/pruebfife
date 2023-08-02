import 'package:flutter/material.dart';

class CardNotificationPushInAppSlideUp extends StatelessWidget {
  const CardNotificationPushInAppSlideUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey.shade400,
        margin: EdgeInsets.symmetric(
          horizontal: 0.01,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 2.8,
            height: MediaQuery.of(context).size.height * 0.12,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    ),
                    child: Image.asset(
                      'assets/image/slide_up_tosh_prueba.png',
                      // height: MediaQuery.of(context).size.height * 0.1,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, left: 20, bottom: 20),
                      child: Text(
                        '¡Lleva tu negocio al siguiente nivel! pide galletas Tosh con 15% de descuento, Pide aquí ...',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons
                            .arrow_forward_ios, 
                        color: Colors.white,
                      ),
                      onPressed: () {})
                    ]
                  )
                )
              );
  }
}
