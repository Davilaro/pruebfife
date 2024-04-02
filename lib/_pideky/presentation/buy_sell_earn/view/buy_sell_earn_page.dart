import 'package:emart/_pideky/domain/buy_sell_earn/model/buy_sell_earn_model.dart';
import 'package:emart/_pideky/presentation/buy_sell_earn/view_model/buy_sell_earn_view_model.dart';
import 'package:emart/_pideky/presentation/buy_sell_earn/widgets/card_ticket.dart';
import 'package:emart/_pideky/presentation/buy_sell_earn/widgets/promo_star.dart';
import 'package:emart/_pideky/presentation/buy_sell_earn/widgets/ticket_description.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class BuySellEarnPage extends StatelessWidget {
  const BuySellEarnPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BuySellEarnViewModel compraVendeGanaViewModel =
        BuySellEarnViewModel.getMyController();
    compraVendeGanaViewModel.getCupons();
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text(
          S.current.buy_sell_earn_title,
          maxLines: 2,
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
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
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
              FutureBuilder(
                  future: compraVendeGanaViewModel.getCupons(),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      List<BuySellEarnModel> cuponsList = snapshot.data;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: cuponsList.length,
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
                                          color: cuponsList[index].colorCupon!),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            width: Get.width * 0.3,
                                            child: Image.network(
                                              cuponsList[index].link!,
                                              errorBuilder: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'assets/image/jar-loading.gif'),
                                            ),
                                          ),
                                          TicketDescription(
                                            compraVendeGana: cuponsList[index],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: cuponsList[index].chispa! == 1
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
                                          color: Color(int.parse(
                                              '0xff${cuponsList[index].colorChispa}')),
                                          child: Text(
                                              "-${cuponsList[index].valorChispa!.toInt()}%",
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
                      );
                    } else {
                      return Center(
                        child: SizedBox.shrink(),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
