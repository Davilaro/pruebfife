import 'package:emart/_pideky/presentation/mi_negocio/view/widgets/editarNumero.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view/widgets/mis_proveedores.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view/widgets/mis_vendedores.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view_model/mi_negocio_view_model.dart';
import 'package:emart/shared/widgets/politicas_datos.dart';
import 'package:emart/shared/widgets/terminos_condiciones.dart';
import 'package:emart/src/modelos/datos_cliente.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/alertas.dart' as alert;
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:emart/src/widget/titulo_pideky.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class MiNegocio extends StatefulWidget {
  MiNegocio({Key? key}) : super(key: key);

  @override
  State<MiNegocio> createState() => _MiNegocioState();
}

class _MiNegocioState extends State<MiNegocio> {
  final MiNegocioViewModel viewModel = Get.find();

  @override
  void initState() {
    if (prefs.usurioLogin == -1) {
      Future.delayed(Duration(seconds: 0)).then((value) {
        alert.alertCustom(context);
      });
    }
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('MyBusinessPage');
    viewModel.cargarArchivos(prefs);
    validarVersionActual(context);
    viewModel.validarVersion();
    //FIREBASE: Llamamos el evento select_content
    TagueoFirebase().sendAnalityticSelectContent(
        "Footer", "Mi Negocio", "", "", "Mi Negocio", 'MainActivity');
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Mi Negocio');
    super.initState();
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
              icon: SvgPicture.asset('assets/image/boton_soporte.svg'),
              onPressed: () => {
                //UXCam: Llamamos el evento clickSoport
                UxcamTagueo().clickSoport(),
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
          BotonActualizar(),
          AccionNotificacion(),
          AccionesBartCarrito(esCarrito: false),
        ],
      ),
      body: RefreshIndicator(
        color: ConstantesColores.azul_precio,
        backgroundColor: ConstantesColores.agua_marina.withOpacity(0.6),
        onRefresh: () async {
          await LogicaActualizar().actualizarDB();

          Navigator.pushReplacementNamed(
            context,
            'tab_opciones',
          ).timeout(Duration(seconds: 3));
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: FutureBuilder(
                initialData: [],
                future: DBProviderHelper.db.consultarDatosCliente(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.data!.length != 0) {
                    DatosCliente sucursal = snapshot.data![0];
                    var capturar =
                        sucursal.telefonoWhatsapp.toString().split('+57');
                    String telefono = capturar.length > 1
                        ? capturar[1]
                        : sucursal.telefonoWhatsapp != null
                            ? ' ${sucursal.telefonoWhatsapp.toString()}'
                            : '';
                    return Column(
                      children: [
                        cardStyle(
                            bodyContainer: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                        Image.asset(
                                          'assets/icon/perfil_img.png',
                                          width: 70,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  'Mi negocio',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: ConstantesColores
                                                          .gris_textos,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Text(
                                                sucursal.razonsocial.toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: ConstantesColores
                                                        .azul_precio,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Dirección: ${sucursal.direccion.toString()}',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: ConstantesColores
                                                        .gris_textos,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Número WhatsApp:$telefono',
                                                maxLines: 4,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: ConstantesColores
                                                        .gris_textos,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ])),
                                  GestureDetector(
                                    onTap: () => editarNumero(context),
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 1, left: 18),
                                        child: Image.asset(
                                          'assets/icon/editar_perfil_img.png',
                                          width: 20,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: HexColor('#EAE8F5'),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 20),
                              child: Text(
                                'Mi cuenta',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ConstantesColores.gris_textos,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MisProveedores())),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            'assets/icon/mis_proveedores_img.png',
                                            alignment: Alignment.center,
                                            width: 35,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Mis proveedores',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 30,
                                      color: ConstantesColores.agua_marina,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: HexColor('#EAE8F5'),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MisVendedores())),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 7),
                                            child: Image.asset(
                                              'assets/icon/mis_vendedores_img.png',
                                              alignment: Alignment.center,
                                              width: 30,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Mis vendedores',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 30,
                                      color: ConstantesColores.agua_marina,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: HexColor('#EAE8F5'),
                            )
                          ],
                        )),
                        cardStyle(
                            bodyContainer: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 20),
                              child: Text(
                                'Términos y condiciones',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ConstantesColores.gris_textos,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () => viewModel.politicasDatosPdf != null
                                    ? verPoliticasCondiciones(
                                        context, viewModel.politicasDatosPdf)
                                    : null,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 7),
                                            child: Image.asset(
                                              'assets/icon/politicas.png',
                                              alignment: Alignment.center,
                                              width: 30,
                                            ),
                                          ),
                                          Container(
                                            width: Get.width * 0.52,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Política y tratamiento de datos',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 30,
                                      color: ConstantesColores.agua_marina,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: HexColor('#EAE8F5'),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              // width: Get.width * 1,
                              child: GestureDetector(
                                onTap: () => viewModel.terminosDatosPdf != null
                                    ? verTerminosCondiciones(
                                        context, viewModel.terminosDatosPdf)
                                    : null,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 4),
                                            child: Image.asset(
                                              'assets/icon/termino_y_condiciones_img.png',
                                              alignment: Alignment.center,
                                              width: 35,
                                            ),
                                          ),
                                          Container(
                                            width: Get.width * 0.52,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Términos y condiciones',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 30,
                                      color: ConstantesColores.agua_marina,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: HexColor('#EAE8F5'),
                            )
                          ],
                        )),
                        Container(
                          margin: EdgeInsets.only(top: 30, left: 29),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icon/logout_img.png',
                                alignment: Alignment.center,
                                width: 30,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        viewModel.iniciarModalCerrarSesion(
                                            context, size, provider)
                                      },
                                      child: Text(
                                        "Cerrar sesión.",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Obx(() => Text(
                                          Constantes().titulo == 'QA'
                                              ? 'Versión QA ${viewModel.version.value}'
                                              : 'Versión ${viewModel.version.value}',
                                          style: TextStyle(
                                              color:
                                                  ConstantesColores.gris_textos,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                })),
      ),
    );
  }

  Widget cardStyle({bodyContainer}) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 27),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: bodyContainer,
    );
  }
}
