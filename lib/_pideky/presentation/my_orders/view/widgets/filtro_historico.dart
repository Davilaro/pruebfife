// ignore_for_file: invalid_use_of_protected_member

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class FiltroHistorico extends StatefulWidget {
  final controlerFiltro;

  FiltroHistorico({Key? key, required this.controlerFiltro}) : super(key: key);

  @override
  _FiltroHistoricoState createState() => _FiltroHistoricoState();
}

class _FiltroHistoricoState extends State<FiltroHistorico> {
  RxString diaInicio = ''.obs;
  RxString mesInicio = ''.obs;
  RxString anoInicio = ''.obs;

  RxString diaFin = ''.obs;
  RxString mesFin = ''.obs;
  RxString anoFin = ''.obs;

  RxString mensajeInformativo = ''.obs;

  RxList<DropdownMenuItem<String>> listDias = <DropdownMenuItem<String>>[].obs;
  RxList<DropdownMenuItem<String>> listMeses = <DropdownMenuItem<String>>[].obs;
  RxList<DropdownMenuItem<String>> listAnos = <DropdownMenuItem<String>>[].obs;
  RxList<DropdownMenuItem<String>> listFinDias =
      <DropdownMenuItem<String>>[].obs;

  final meses = {
    1: 'Enero',
    2: 'Febrero',
    3: 'Marzo',
    4: 'Abril',
    5: 'Mayo',
    6: 'Junio',
    7: 'Julio',
    8: 'Agosto',
    9: 'Septiembre',
    10: 'Octubre',
    11: 'Noviembre',
    12: 'Diciembre'
  };

  @override
  void initState() {
    super.initState();
    cargarFechas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          title: Text(S.current.filter,
              style: TextStyle(color: HexColor("#41398D"), fontSize: 27)),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ConstantesColores.color_fondo_gris,
            statusBarIconBrightness: Brightness.dark,
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          actions: [iconLimpiarFiltro()],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    child: Text(
                        S.current.choose_the_period_to_filter_your_orders,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ),
                  Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 2),
                                    child: Text(S.current.start_date,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey))),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Año inicio
                                    Obx(() => _dropFecha(listAnos, 'Año',
                                        'inicio', anoInicio.value.toString())),
                                    // Mes inicio
                                    Obx(() => _dropFecha(listMeses, 'Mes',
                                        'inicio', mesInicio.value.toString())),
                                    // Dia Inicio
                                    Obx(() => _dropFecha(listDias, 'Dia',
                                        'inicio', diaInicio.value.toString())),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 30, bottom: 10, left: 2),
                                    child: Text('Fecha final',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey))),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Año final
                                    Obx(() => _dropFecha(listAnos, 'Año', 'fin',
                                        anoFin.value.toString())),
                                    // Mes final
                                    Obx(() => _dropFecha(listMeses, 'Mes',
                                        'fin', mesFin.value.toString())),
                                    // Dia final
                                    Obx(() => _dropFecha(listFinDias, 'Dia',
                                        'fin', diaFin.value.toString())),
                                  ],
                                ),
                              ],
                            ),
                            Obx(() => Visibility(
                                  visible: mensajeInformativo.value != '',
                                  child: Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Text(
                                      mensajeInformativo.value,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                )),
                            Container(
                                width: Get.width,
                                margin: EdgeInsets.symmetric(vertical: 25),
                                child: Divider(
                                  thickness: 2,
                                )),
                            Container(
                                child: Text('Periodo seleccionado',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey))),
                            Obx(() => Center(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(top: 30, bottom: 80),
                                      child: Text(
                                          '${diaInicio.value.isNotEmpty ? diaInicio.value : ""} ${meses[toInt(mesInicio.value)] ?? ""} - ${diaFin.isNotEmpty ? diaFin.value : ""} ${meses[toInt(mesFin.value)] ?? ""} ${anoFin.isNotEmpty ? anoFin.value : ""}',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: ConstantesColores
                                                  .azul_precio))),
                                )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Center(
                                child: Container(
                                  width: Get.width * 0.8,
                                  height: Get.height * 0.05,
                                  child: CustomButton(
                                    onPressed: () => confirmarFiltro(context),
                                    text: 'Filtrar',
                                    sizeText: 18,
                                    backgroundColor:
                                        ConstantesColores.agua_marina,
                                    borderRadio: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ]),
          ),
        ));
  }

  Widget _dropFecha(RxList<DropdownMenuItem<String>> dropdownItems,
      String hintText, String tipoFecha, String value) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          color: HexColor("#E4E3EC"),
          borderRadius: BorderRadius.circular(50),
        ),
        margin: EdgeInsets.symmetric(horizontal: 2),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Text(
              hintText,
              style: TextStyle(
                  fontSize: 15,
                  color: ConstantesColores.azul_precio,
                  fontWeight: FontWeight.bold),
            ),
            value: value,
            items: dropdownItems.value,
            iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: ConstantesColores.azul_precio,
                ),
                iconSize: 30),
            onChanged: (String? value) {
              validarValue(value!, hintText, tipoFecha);
            },
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: HexColor("#E4E3EC"),
              ),
              elevation: 8,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              maxHeight: 200
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 40
            ),
          ),
        ),
      ),
    );
  }

  validarValue(String value, String hintText, String tipoFecha) {
    if (hintText == 'Dia') {
      tipoFecha == 'inicio' ? diaInicio.value = value : diaFin.value = value;
    }
    if (hintText == 'Mes') {
      if (tipoFecha == 'inicio') {
        diaInicio.value = '';
        mesInicio.value = value;
        listDias.value = widget.controlerFiltro
            .getDropdownItemsDia(mesInicio.value, anoInicio.value);
      } else {
        diaFin.value = '';
        mesFin.value = value;
        listFinDias.value = widget.controlerFiltro
            .getDropdownItemsDia(mesFin.value, anoFin.value);
      }
    }
    if (hintText == 'Año') {
      if (tipoFecha == 'inicio') {
        diaInicio.value = '';
        anoInicio.value = value;
        listDias.value = widget.controlerFiltro
            .getDropdownItemsDia(mesInicio.value, anoInicio.value);
      } else {
        diaFin.value = '';
        anoFin.value = value;
        listFinDias.value = widget.controlerFiltro
            .getDropdownItemsDia(mesFin.value, anoFin.value);
      }
    }
  }

  confirmarFiltro(BuildContext context) async {
    if (diaInicio.isNotEmpty &&
        diaFin.isNotEmpty &&
        mesInicio.isNotEmpty &&
        mesFin.isNotEmpty &&
        anoInicio.isNotEmpty &&
        anoFin.isNotEmpty) {
      var fechaInicial =
          '${anoInicio.value}-${mesInicio.value.toString().length > 1 ? mesInicio.value : '0${mesInicio.value}'}-${diaInicio.value.toString().length > 1 ? diaInicio.value : '0${diaInicio.value}'}';
      var fechaFin =
          '${anoFin.value}-${mesFin.value.toString().length > 1 ? mesFin.value : '0${mesFin.value}'}-${diaFin.value.toString().length > 1 ? diaFin.value : '0${diaFin.value}'}';
      var num1 = fechaInicial.replaceAll('-', '');
      var num2 = fechaFin.replaceAll('-', '');
      if (toInt(num1) < toInt(num2)) {
        if (await widget.controlerFiltro
            .validarFiltro(context, fechaInicial, fechaFin)) {
          mensajeInformativo.value = '';
          widget.controlerFiltro.setFechaInicial(fechaInicial);
          widget.controlerFiltro.setFechaFinal(fechaFin);
          Navigator.pop(context);
        }
      } else {
        mensajeInformativo.value =
            'Por favor selecciona una fecha inicial menor a la final';
      }
    } else {
      widget.controlerFiltro.setFechaFinal('-1');
      widget.controlerFiltro.setFechaInicial('-1');

      Navigator.pop(context);
    }
  }

  validarInicio() {
    if (widget.controlerFiltro.fechaInicial.value != '-1' ||
        widget.controlerFiltro.fechaFinal.value != '-1') {
      DateTime _fechaInicial =
          DateTime.parse(widget.controlerFiltro.fechaInicial.value);
      DateTime _fechaFinal =
          DateTime.parse(widget.controlerFiltro.fechaFinal.value);
      diaInicio.value = _fechaInicial.day.toString();
      mesInicio.value = _fechaInicial.month.toString();
      anoInicio.value = _fechaInicial.year.toString();

      diaFin.value = _fechaFinal.day.toString();
      mesFin.value = _fechaFinal.month.toString();
      anoFin.value = _fechaFinal.year.toString();
    }
  }

  Widget iconLimpiarFiltro() {
    return OutlinedButton(
      style:
          OutlinedButton.styleFrom(side: BorderSide(color: Colors.transparent)),
      onPressed: () => limpiarFiltro(),
      child: Row(
        children: [
          Image.asset(
            'assets/image/limpiar_filtro_img.png',
            width: Get.width * 0.07,
          ),
          Container(
            width: 60,
            child: Text(
              'Limpiar Filtro',
              maxLines: 2,
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  limpiarFiltro() {
    widget.controlerFiltro.setFechaFinal('-1');
    widget.controlerFiltro.setFechaInicial('-1');

    diaInicio.value = '';
    diaFin.value = '';
    mesInicio.value = '';
    mesFin.value = '';
    anoInicio.value = '';
    anoFin.value = '';
  }

  cargarFechas() {
    listFinDias.value = widget.controlerFiltro.getDropdownItemsDia('', '');
    listMeses.value = widget.controlerFiltro.getDropdownItemsMes();
    listAnos.value = widget.controlerFiltro.getDropdownItemsAno();
    listDias.value = widget.controlerFiltro.getDropdownItemsDia('', '');
    validarInicio();
  }
}
