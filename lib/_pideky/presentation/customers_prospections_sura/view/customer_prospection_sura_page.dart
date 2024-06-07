import 'package:emart/_pideky/presentation/customers_prospection/widgets/body_customers_prospection.dart';
import 'package:emart/_pideky/presentation/customers_prospections_sura/widgets/body_customers_prospection_sura.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';

class CustomersProspectionSuraPage extends StatelessWidget {
  const CustomersProspectionSuraPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Customer Prospection Sura');
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/background_customers_prospection.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: ConstantesColores.azul_aguamarina_botones,
                    size: 35,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ),
            BodyCustomersProspectionSura(),
          ],
        ),
      ),
    );
  }
}
