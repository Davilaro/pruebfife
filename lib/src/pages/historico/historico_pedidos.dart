import 'package:emart/src/controllers/controller_historico.dart';
import 'package:emart/src/pages/historico/widgets/filtro_historico.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/expansion_card.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:emart/src/widget/titulo_pideky.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../widget/acciones_carrito_bart.dart';
import '../../widget/dounser.dart';
import 'package:get/get.dart';

final Debouncer onSearchDebouncer =
    new Debouncer(delay: new Duration(milliseconds: 500));
TextEditingController _controladorFiltro = new TextEditingController();

class HistoricoPedidos extends StatefulWidget {
  const HistoricoPedidos({
    Key? key,
  }) : super(key: key);

  @override
  _HistoricoPedidosState createState() => _HistoricoPedidosState();
}

class _HistoricoPedidosState extends State<HistoricoPedidos> {
  final controllerHistorico = Get.find<ControllerHistorico>();
  // ControllerHistorico catalogSearchViewModel = Get.put(ControllerHistorico());

  @override
  void initState() {
    super.initState();
    //FIREBASE: Llamamos el evento select_content
    TagueoFirebase().sendAnalityticSelectContent(
        "Footer", "Historico", "", "", "Historico", 'MainActivity');
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Histórico');
    validarVersionActual(context);
    controllerHistorico.inicializarController();
  }

  String _filtro = "-1";

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('HistoricalPage');
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      body: Container(
        child: RefreshIndicator(
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
            child: Center(
              child: Column(
                children: [
                  _buscador(size),
                  Obx(() => FutureBuilder<List<dynamic>>(
                      future: DBProviderHelper.db.consultarHistoricos(
                          _filtro,
                          controllerHistorico.fechaInicial.value,
                          controllerHistorico.fechaFinal.value),
                      builder:
                          (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          var cantidad = snapshot.data?.length;
                          if (cantidad! > 0) {
                            var historicos = snapshot.data;
                            return Column(
                              children: [
                                for (int i = historicos!.length - 1;
                                    i >= 0;
                                    i--)
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      width: size.width * 0.9,
                                      margin: EdgeInsets.only(bottom: 14),
                                      child: ExpansionCard(
                                          historico: historicos[i])),
                              ],
                            );
                          } else {
                            return Column(
                                children: [Text("No hay registros!")]);
                          }
                        } else {
                          return Column(children: [Text("No hay registros!")]);
                        }
                      })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buscador(size) {
    return Container(
      width: size.width * 0.9,
      child: Row(
        children: [
          Container(
            width: size.width * 0.7,
            decoration: BoxDecoration(
              color: HexColor("#E4E3EC"),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(right: 20.0, top: 20, bottom: 20),
            child: TextField(
              onChanged: (valor) {
                setState(() {
                  _filtro = _controladorFiltro.text == ""
                      ? "-1"
                      : _controladorFiltro.text;
                });
              },
              controller: _controladorFiltro,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 12),
                border: InputBorder.none,
                hintText: "Buscar Pedidos",
                suffixIcon: Icon(
                  Icons.search,
                  color: HexColor("#43398E"),
                  size: 36,
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FiltroHistorico(
                          controlerFiltro: controllerHistorico,
                        ))),
            child: Container(
              margin: const EdgeInsets.only(right: 0),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/image/filtro_btn.svg',
                      fit: BoxFit.fill)),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
