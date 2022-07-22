import 'package:emart/src/controllers/bannnersController.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/controllers/encuesta_controller.dart';
import 'package:emart/src/modelos/multimedia.dart';
import 'package:emart/src/pages/principal_page/widgets/categorias_card.dart';
import 'package:emart/src/pages/principal_page/widgets/encuesta_form.dart';
import 'package:emart/src/pages/principal_page/widgets/products_card.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/search_fuzzy.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:emart/src/pages/principal_page/widgets/ofertas_banner.dart';
import 'package:emart/src/pages/catalogo/widgets/opciones.dart';
import 'package:emart/src/widget/reproduct_video.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:emart/src/widget/titulo_pideky.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

bool limpiar = false;

class PrincipalPage extends StatefulWidget {
  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final controllerEncuesta = Get.put(EncuestaControllers());

  final cargoControllerBase = Get.put(CambioEstadoProductos());
  final controllerProducto = Get.put(ControllerProductos());
  final cargoConfirmar = Get.find<ControlBaseDatos>();

  var nombreTienda = prefs.usuarioRazonSocial;

  @override
  void initState() {
    super.initState();
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('HomePage');
    controllerProducto.getAgotados();
    validarVersionActual(context);
    //FIREBASE: Llamamos el evento select_content
    TagueoFirebase().sendAnalityticSelectContent(
        "Footer", "Home", "", "", "Home", 'PrincipalPage');
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Inicio');
    _cargarLista();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<OpcionesBard>(context);

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: TituloPideky(size: size),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 2.0, 0, 0),
          child: Container(
            width: 100,
            child: new IconButton(
              icon: SvgPicture.asset('assets/boton_soporte.svg'),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Soporte(
                            numEmpresa: 1,
                          )),
                ),
              },
            ),
          ),
        ),
        elevation: 0,
        actions: <Widget>[
          AccionNotificacion(),
          AccionesBartCarrito(esCarrito: false),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              //BUSCADOR
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: _buscadorPrincipal(context),
              ),
              //OPCIONES DINAMICAS
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: BtnOpciones(size: size, provider: provider),
              ),
              //OFERTAS QUE MUESTRA LOS BANNERS
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                height: Get.height * 0.22,
                width: double.infinity,
                child: OfertasBanner(),
              ),
              //IMPERDIBLES
              Container(
                  margin: EdgeInsets.only(top: 10),
                  height: Get.height * 0.4,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: FutureBuilder(
                              initialData: [],
                              future: DBProvider.db.consultarSucursal(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                var tituloImperdible = prefs.usurioLogin == -1
                                    ? 'tí'
                                    : snapshot.data;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: Get.width * 0.73,
                                      child: Text(
                                        'Imperdibles para $tituloImperdible',
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: HexColor("#41398D"),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          onClickVerMas(
                                              'Imperdibles', provider);
                                        },
                                        child: Text(
                                          'Ver más',
                                          style: TextStyle(
                                              color:
                                                  ConstantesColores.agua_marina,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline),
                                        ))
                                  ],
                                );
                              })),
                      Expanded(child: ProductsCard(2))
                    ],
                  )),
              //PROMOS
              Container(
                  height: Get.height * 0.44,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Promo de la semana',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: HexColor("#41398D"),
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  onClickVerMas('Promos', provider);
                                },
                                child: Text(
                                  'Ver más',
                                  style: TextStyle(
                                      color: ConstantesColores.agua_marina,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                ))
                          ],
                        ),
                      ),
                      Expanded(child: ProductsCard(1))
                    ],
                  )),
              //MULTIMEDIA
              FutureBuilder(
                  initialData: [],
                  future: DBProvider.db.consultarMultimedia(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data == null || snapshot.data.length == 0) {
                      return Container();
                    } else {
                      Multimedia multimedia = snapshot.data[0];
                      // cargoConfirmar.setUrlMultimedia(multimedia.link);
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.only(top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, left: 3),
                              child: Text(
                                'Lo más visto por clientes vecinos',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: HexColor("#41398D"),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              height: Get.height * 0.25,
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ReproductVideo(multimedia),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
              //CATEGORIAS DESTACAS
              Container(
                  // height: Get.height * 0.3,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Categorías destacadas para ti ',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: HexColor("#41398D"),
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  onClickVerMas('Categorías', provider);
                                },
                                child: Text(
                                  'Ver más',
                                  style: TextStyle(
                                      color: ConstantesColores.agua_marina,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                ))
                          ],
                        ),
                      ),
                      Container(
                          height: Get.height * 0.2, child: CategoriasCard()),
                    ],
                  )),
              //ENCUESTA
              FutureBuilder(
                  initialData: [],
                  future: DBProvider.db.consultarEncuesta(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data.length == 0) {
                      return Container();
                    } else {
                      double size = 90.0 * snapshot.data[0].parametro.length;
                      print('valor $size');
                      return Obx(() => Visibility(
                            visible: controllerEncuesta.isVisibleEncuesta.value,
                            child: Container(
                                constraints: BoxConstraints(
                                    minHeight: 220,
                                    maxHeight: size < 220 ? 220 : size),
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 15, bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: EncuestaForm(snapshot.data[0])),
                          ));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  _buscadorPrincipal(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchFuzzy()));
        },
        child: TextField(
          enabled: false,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Encuentra aquí todo lo que necesitas',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Icon(
                  Icons.search,
                  color: HexColor("#41398D"),
                )),
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
          ),
        ),
      ),
    );
  }

  void _cargarLista() async {
    PedidoEmart.listaFabricante =
        await DBProvider.db.consultarFricanteGeneral();
  }

  void onClickVerMas(String ubicacion, provider) async {
    // List resData = await DBProvider.db.consultarSecciones();
    for (var i = 0; i < cargoConfirmar.seccionesDinamicas.length; i++) {
      if (cargoConfirmar.seccionesDinamicas[i].descripcion.toLowerCase() ==
          ubicacion.toLowerCase()) {
        //FIREBASE: Llamamos el evento select_content
        TagueoFirebase().sendAnalityticSelectContent(
            "SeeMore",
            "${cargoConfirmar.seccionesDinamicas[i].descripcion}",
            "",
            "",
            "${cargoConfirmar.seccionesDinamicas[i].descripcion}",
            'HomePage');
        //UXCam: Llamamos el evento seeMore
        UxcamTagueo().seeMore(
            "${cargoConfirmar.seccionesDinamicas[i].descripcion}", provider);
        provider.selectOptionMenu = 1;
        provider.setIsLocal = 0;
        cargoConfirmar.tabController.index = i;
        cargoConfirmar.cargoBaseDatos(i);
        break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
