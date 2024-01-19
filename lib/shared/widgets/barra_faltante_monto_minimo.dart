import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BarraFaltanteMontoMin extends StatelessWidget {
  final double minimumAmount;
  final double currentAmount;

  BarraFaltanteMontoMin({
    required this.minimumAmount,
    required this.currentAmount,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (currentAmount / minimumAmount).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        children: [
          LinearPercentIndicator(
            // percent: percentage,
            // progressColor: percentage >= 1.0 ? Colors.green : Colors.blue,
            // backgroundColor: Colors.grey[300],
            // barRadius: Radius.circular(20),
            animation: true,
            animationDuration: 2500,
            width: 420.0,
            lineHeight: 14.0,
            percent: percentage,
            barRadius: Radius.circular(10),
            backgroundColor: Colors.grey,
            linearGradient: LinearGradient(colors: <Color>[ConstantesColores.empodio_verde, ConstantesColores.azul_precio])
           // progressColor: percentage >= 1.0 ? Colors.green : Colors.blue,
          ),
          Positioned(
            //top: 50,
            right: 70,
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0, end: percentage),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(
                      0.0, value * 250), // 250 is the height of the container
                  child: child,
                );
              },
              child: Container(
                color: Colors.amber,
                  //padding: EdgeInsets.all(8.0),
                  child: Image.asset('assets/icon/Icon_entrega 1.png',
                      scale: 3.5
                     )
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
