import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/club_ganadores/view/club_ganadores_page.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view/widgets/editarNumero.dart';
import 'package:emart/_pideky/presentation/mis_pagos_nequi/view/mis_pagos_nequi.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view/widgets/mis_proveedores.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view/widgets/mis_vendedores.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view_model/mi_negocio_view_model.dart';
import 'package:emart/_pideky/presentation/mis_estadisticas/view/mis_estadisticas.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/politicas_datos.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/shared/widgets/terminos_condiciones.dart';
import 'package:emart/src/modelos/datos_cliente.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
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
        print("negocio");
        alertCustom(context);
      });
    }
    if (prefs.paisUsuario == "CO") {
      viewModel.pais.value = "CO";
    } else {
      viewModel.pais.value = "CR";
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
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: FutureBuilder(
                initialData: [],
                future: DBProviderHelper.db.consultarDatosCliente(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.data!.length != 0) {
                    DatosCliente sucursal = snapshot.data![0];
                    String telefono = sucursal.telefonoWhatsapp.toString();
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
                                                  S.current.my_business,
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
                                                S.current.address(sucursal
                                                    .direccion
                                                    .toString()),
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: ConstantesColores
                                                        .gris_textos,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  AutoSizeText(
                                                    S.current.whatsApp_number(
                                                        telefono),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: ConstantesColores
                                                            .gris_textos,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        editarNumero(context),
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 1,
                                                            left: 18),
                                                        child: Image.asset(
                                                          'assets/icon/editar_perfil_img.png',
                                                          width: 20,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 3),
                                                child: GestureDetector(
                                                  onTap: () async =>
                                                      viewModel.copiarCCUP(
                                                          sucursal
                                                              .codigoUnicoPideky,
                                                          context),
                                                  child: AutoSizeText(
                                                    'CCUP: ${sucursal.codigoUnicoPideky}',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 1,
                                                        color: Color.fromARGB(
                                                            255, 67, 66, 66),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ])),
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
                                S.current.my_account,
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
                                              S.current.my_suppliers,
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
                                              S.current.my_vendors,
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
                                        builder: (context) =>
                                            MisEstadisticas())),
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
                                              'assets/icon/mis_estadisticas.png',
                                              alignment: Alignment.center,
                                              width: 30,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              S.current.my_statistics,
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
                            Obx(
                              () => viewModel.pais.value == "CO"
                                  ? Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ClubGanadoresPage())),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 7),
                                                        child: Image.asset(
                                                          'assets/icon/Icon_club_ganadores.png',
                                                          alignment:
                                                              Alignment.center,
                                                          width: 30,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        width:
                                                            Get.width * 0.475,
                                                        child: Text(
                                                          S.current
                                                              .winners_club,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 30,
                                                  color: ConstantesColores
                                                      .agua_marina,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: HexColor('#EAE8F5'),
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                            ),
                            Obx(() => viewModel.pais.value == "CO"
                                ? Column(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MisPagosNequiPage())),
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
                                                      margin: EdgeInsets.only(
                                                          right: 7),
                                                      child: Image.asset(
                                                        'assets/icon/mis_pagos_nequi.png',
                                                        alignment:
                                                            Alignment.center,
                                                        width: 30,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        S.current
                                                            .my_nequi_payments,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 30,
                                                color: ConstantesColores
                                                    .agua_marina,
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
                                  )
                                : Container())
                          ],
                        )),
                        cardStyle(
                            bodyContainer: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 20),
                              child: Text(
                                S.current.terms_conditions,
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
                                              S.current
                                                  .policy_and_data_processing,
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
                              child: GestureDetector(
                                onTap: () => viewModel.terminosDatosPdf != null
                                    ? verTerminosCondiciones(context,
                                        viewModel.terminosDatosPdf, false)
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
                                              S.current.terms_conditions,
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
                          margin: EdgeInsets.only(top: 30, left: 5, right: 15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icon/logout_img.png',
                                      alignment: Alignment.center,
                                      width: 30,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () => {
                                              viewModel
                                                  .iniciarModalCerrarSesion(
                                                      context, size, provider)
                                            },
                                            child: Text(
                                              S.current.log_out,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Obx(() => Text(
                                                Constantes().titulo == 'QA'
                                                    ? '${S.current.version} QA ${viewModel.version.value}'
                                                    : '${S.current.version} ${viewModel.version.value}',
                                                style: TextStyle(
                                                    color: ConstantesColores
                                                        .gris_textos,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 40,),
                                GestureDetector(
                                  onTap: () async {
                                    prefs.typeCollaborator != "2"
                                        ? viewModel.iniciarModalEliminarUsuario(
                                            context, size, provider)
                                        : mostrarAlert(
                                            context,
                                            "No puedes eliminar la cuenta ya que te encuentras en modo colaborador",
                                            null);
                                  },
                                  child: Row(children: [
                                    Image.asset(
                                      "assets/icon/eliminar_cuenta.png",
                                      alignment: Alignment.center,
                                      width: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      S.current.delete_account,
                                      style: TextStyle(
                                          color: ConstantesColores.gris_textos,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ]),
                                )
                              ]),
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
