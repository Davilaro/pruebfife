import 'package:carousel_slider/carousel_slider.dart';
import 'package:emart/src/controllers/bannnersController.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class OfertasBanner extends StatefulWidget {
  @override
  State<OfertasBanner> createState() => _OfertasBannerState();
}

class _OfertasBannerState extends State<OfertasBanner> {
  int _current = 0;

  final prefs = new Preferencias();

  final CarouselController _controller = CarouselController();

  final _controllesBannes = Get.find<BannnerControllers>();
  final cargoConfirmar = Get.find<CambioEstadoProductos>();

  @override
  void initState() {
    super.initState();
    cargarBanners();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartViewModel>(context);

    return Obx(() => _controllesBannes.cargoDatos.value == false
        ? Container(
            child: Center(
              child: Image.asset('assets/image/jar-loading.gif'),
            ),
          )
        : Column(
            children: [
              Expanded(
                child: Container(
                  height: Get.height * 0.34,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                    items: _controllesBannes.listaBanners.map((item) {
                      return InkWell(
                        onTap: () {
                          //FIREBASE: Llamamos el evento select_promotion
                          TagueoFirebase().sendAnalityticSelectPromotion(
                              "home",
                              item.nombreBanner,
                              item.link,
                              item.tipofabricante,
                              item.idBanner);
                          //UXCam: Llamamos el evento selectBanner
                          UxcamTagueo().selectBanner(item.nombreBanner, "Home");
                          _controllesBannes.validarOnClick(item, context,
                              provider, cargoConfirmar, prefs, '');
                        },
                        child: Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                item?.link,
                                fit: BoxFit.fill,
                                errorBuilder: (context, url, error) =>
                                    Image.asset('assets/image/jar-loading.gif'),
                              )),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    _controllesBannes.listaBanners.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                        width: _current == entry.key ? 20.0 : 9.0,
                        height: 10.0,
                        padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 1.3),
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
          ));
  }

  void cargarBanners() async {
    final listaBanners = await DBProvider.db.cargarBannersHomeSql();
    _controllesBannes.cargarDatosBanner(listaBanners);
    _controllesBannes.listaBanners.map((e) {
      //FIREBASE: Llamamos el evento view_promotion
      TagueoFirebase().sendAnalityticViewPromotion("home", e);
    }).toList();
  }
}
