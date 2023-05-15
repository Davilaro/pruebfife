import 'package:carousel_slider/carousel_slider.dart';
import 'package:emart/_pideky/domain/club_ganadores_pideky/model/imagen_premios_model.dart';
import 'package:emart/_pideky/domain/club_ganadores_pideky/model/puntos_obtenidos.dart';
import 'package:emart/_pideky/presentation/club_ganadores/view_mdel/club_ganadores_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../../../src/preferences/cont_colores.dart';

class ClubGanadoresPage extends StatelessWidget {
  const ClubGanadoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clubGanadoresViewModel = Get.find<ClubGanadoresViewModel>();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('WinnersClubPage');
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text(S.current.winners_club,
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold)),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.winners_club_tittle,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 13,
                          color: ConstantesColores.gris_textos,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            child: Image.asset(
                                'assets/image/Img_club_ganadores.png'),
                          ),
                          Text(
                            "Mis puntos disponibles",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ConstantesColores.azul_precio),
                          ),
                          FutureBuilder(
                              future: clubGanadoresViewModel.cargarPuntos(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: CircularProgressIndicator());
                                  default:
                                    if (snapshot.hasError) {
                                      return Text(
                                          S.current.no_information_to_display);
                                    } else {
                                      List<PuntosObtenidos> puntos =
                                          snapshot.data;
                                      print("data $puntos");
                                      var tempPunt = toInt(puntos.length > 0
                                          ? puntos.first.puntosDisponibles
                                              .toString()
                                          : "0");

                                      NumberFormat formatNumber =
                                          new NumberFormat("#,##0.00");
                                      var result = formatNumber
                                          .format(tempPunt)
                                          .replaceAll(',00', '');
                                      return Text(
                                        result,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                ConstantesColores.azul_precio),
                                      );
                                    }
                                }
                              })
                        ],
                      ),
                      height: 250,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Puedes usar tus puntos en:",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: ConstantesColores.azul_precio),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    height: Get.height * 0.20,
                    width: double.infinity,
                    child: FutureBuilder(
                      future: clubGanadoresViewModel.cargarImagenesPremios(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          List<ImagenPremios> lista = snapshot.data;
                          return lista.isNotEmpty
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CarouselSlider(
                                        items: lista
                                            .map(
                                              (element) => Container(
                                                width: Get.width * 0.5,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Image.network(
                                                  element.url.toString(),
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          'assets/image/jar-loading.gif'),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        carouselController:
                                            clubGanadoresViewModel
                                                .carouselController,
                                        options: CarouselOptions(
                                          initialPage: 0,
                                          autoPlay: true,
                                          aspectRatio: 3,
                                          viewportFraction: 0.6,
                                          autoPlayInterval:
                                              Duration(seconds: 5),
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 800),
                                          enlargeCenterPage: false,
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: IconButton(
                                                splashColor: Colors.transparent,
                                                color: ConstantesColores
                                                    .agua_marina,
                                                onPressed: () {
                                                  clubGanadoresViewModel
                                                      .carouselController
                                                      .previousPage(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  800));
                                                },
                                                icon: Icon(Icons
                                                    .arrow_back_ios_new_rounded)),
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.white
                                                    .withOpacity(0.8)),
                                          ),
                                          Container(
                                            child: IconButton(
                                                splashColor: Colors.transparent,
                                                color: ConstantesColores
                                                    .agua_marina,
                                                onPressed: () {
                                                  clubGanadoresViewModel
                                                      .carouselController
                                                      .nextPage(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  800));
                                                },
                                                icon: Icon(Icons
                                                    .arrow_forward_ios_rounded)),
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.white
                                                    .withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox.shrink();
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              BotonAgregarCarrito(
                  borderRadio: 25,
                  width: Get.width * 0.85,
                  height: 50,
                  color: ConstantesColores.azul_aguamarina_botones,
                  onTap: () async {
                    clubGanadoresViewModel.launchUrl();
                  },
                  text: 'Redimir en Club de Ganadores Pideky')
            ],
          ),
        ),
      ),
    );
  }
}
