import 'package:carousel_slider/carousel_slider.dart';
import 'package:emart/src/controllers/bannnersController.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class OfertasInterna extends StatefulWidget {
  final String? nombreFabricante;

  const OfertasInterna({Key? key, required this.nombreFabricante})
      : super(key: key);

  @override
  State<OfertasInterna> createState() => _OfertasInternaState();
}

class _OfertasInternaState extends State<OfertasInterna> {
  final prefs = new Preferencias();
  List<dynamic>? _listaBanners;
  int _current = 0;

  final CarouselController _controller = CarouselController();
  final bannerController = Get.find<BannnerControllers>();
  final cargoConfirmar = Get.find<CambioEstadoProductos>();

  @override
  void initState() {
    super.initState();
    _listaBanners = [];
    _cargarListaBanner();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarroModelo>(context);

    return _listaBanners?.length == 0
        ? Container(
            child: Center(
              child: Image.asset('assets/jar-loading.gif'),
            ),
          )
        : Column(
            children: [
              Expanded(
                child: Container(
                  height: Get.height * 0.34,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 1,
                      viewportFraction: 0.8,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      enlargeCenterPage: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: _listaBanners!.map((item) {
                      return InkWell(
                        onTap: () {
                          //FIREBASE: Llamamos el evento select_promotion
                          TagueoFirebase().sendAnalityticSelectPromotion(
                              "Promo",
                              item.nombreBanner,
                              item.link,
                              item.tipofabricante,
                              item.idBanner);
                          bannerController.validarOnClick(item, context,
                              provider, cargoConfirmar, prefs, 'Promo');
                        },
                        child: Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child:
                                  Image.network(item.link, fit: BoxFit.fill)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _listaBanners!.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                        width: _current == entry.key ? 20.0 : 9.0,
                        height: 10.0,
                        padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            shape: BoxShape.rectangle,
                            color: _current == entry.key
                                ? HexColor('f9744b')
                                : Colors.grey[300])),
                  );
                }).toList(),
              ),
            ],
          );
  }

  void _cargarListaBanner() async {
    _listaBanners =
        await DBProvider.db.cargarBannersSql(widget.nombreFabricante);
    _listaBanners?.map((e) {
      //FIREBASE: Llamamos el evento view_promotion
      TagueoFirebase().sendAnalityticViewPromotion("proveedor", e);
    }).toList();
    setState(() {});
  }
}
