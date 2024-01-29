import 'package:emart/_pideky/presentation/compra_vende_gana/view_model/compra_vende_gana_view_model.dart';
import 'package:emart/_pideky/presentation/compra_vende_gana/widgets/card_ticket.dart';
import 'package:emart/_pideky/presentation/compra_vende_gana/widgets/promo_star.dart';
import 'package:emart/_pideky/presentation/compra_vende_gana/widgets/ticket_description.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CompraVendeGanaPage extends StatelessWidget {
  const CompraVendeGanaPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final compraVendeGanaViewModel = Get.find<CompraVendeGanaViewModel>();
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text(
          S.current.buy_sell_earn_title,
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontWeight: FontWeight.bold),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          BotonActualizar(),
          AccionNotificacion(),
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.current.buy_sell_earn_description,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: ConstantesColores.gris_textos,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      compraVendeGanaViewModel.compraVendeGanaList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: Get.height * 0.22,
                      width: Get.width * 0.9,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CustomPaint(
                              painter: CardTicket(
                                  color: compraVendeGanaViewModel
                                      .compraVendeGanaList[index].colorCupon),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      width: Get.width * 0.3,
                                      child: Image.network(
                                        compraVendeGanaViewModel
                                            .compraVendeGanaList[index].link,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            Image.asset(
                                                'assets/image/logo_login.png'),
                                      )),
                                  TicketDescription(
                                    compraVendeGanaModel:
                                        compraVendeGanaViewModel
                                            .compraVendeGanaList[index],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: compraVendeGanaViewModel
                                        .compraVendeGanaList[index].chispa ==
                                    1
                                ? true
                                : false,
                            child: Positioned(
                              top: Get.height * 0.02,
                              left: Get.width * 0.25,
                              child: ClipPath(
                                clipper: PromoStar(10),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 55,
                                  height: 55,
                                  color: Color(toInt(
                                      "0xff${compraVendeGanaViewModel.compraVendeGanaList[index].colorChispa}")),
                                  child: Text(
                                      "-${compraVendeGanaViewModel.compraVendeGanaList[index].valorChispa.toInt()}%",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
