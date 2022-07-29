import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emart/src/controllers/controller_historico.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/dropdown_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

DateTime? _selectedDate;
DateTime? _selectedDate2;

class FiltroHistorico2 extends StatefulWidget {
  FiltroHistorico2({Key? key}) : super(key: key);

  @override
  _FiltroHistoricoState createState() => _FiltroHistoricoState();
}

class _FiltroHistoricoState extends State<FiltroHistorico2> {
  final controlerHistorico = Get.find<ControllerHistorico>();

  TextEditingController diaInicioController = TextEditingController();
  TextEditingController mesInicioController = TextEditingController();
  TextEditingController anoInicioController = TextEditingController();

  TextEditingController diaFinController = TextEditingController();
  TextEditingController mesFinController = TextEditingController();
  TextEditingController anoFinController = TextEditingController();

  TextEditingController hola = TextEditingController();

  List<String> listDias = [];
  List<String> listMeses = [];
  List<String> listAnos = [];

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
    // TODO: implement initState
    dropdownItemsDia();
    dropdownItemsMes();
    dropdownItemsAno();
    validarInicio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Filtro',
              style: TextStyle(color: HexColor("#41398D"), fontSize: 27)),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          actions: [iconLimpiarFiltro()],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                color: ConstantesColores.color_fondo_gris,
                height: Get.height,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      child: Text('Elige el periodo para filtrar tus pedidos',
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
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        height: Get.height * 0.7,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          overflow: Overflow.visible,
                          children: [
                            //Fecha Final
                            Positioned(
                              top: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 30),
                                      child: Text('Fecha final',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey))),
                                  Container(
                                    width: Get.width * 0.8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Año final
                                        inputFecha('Año', anoFinController,
                                            () => cargarFechaFinal()),
                                        // Mes final
                                        inputFecha('Mes', mesFinController,
                                            () => cargarFechaFinal()),
                                        // Dia final
                                        inputFecha('Día', diaFinController,
                                            () => cargarFechaFinal()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Text('Fecha de inicio',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey))),
                                Container(
                                  width: Get.width * 0.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Año inicio
                                      _dropFecha(
                                          'Año',
                                          listAnos,
                                          TextInputType.number,
                                          anoInicioController),
                                      // Mes inicio
                                      _dropFecha(
                                          'Mes',
                                          listMeses,
                                          TextInputType.text,
                                          mesInicioController),
                                      // Dia Inicio
                                      _dropFecha(
                                          'Dia',
                                          listDias,
                                          TextInputType.number,
                                          diaInicioController),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Positioned(
                              top: 280,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Text('Periodo seleccionado',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey))),
                                  Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 30, bottom: 130),
                                        child: Text(
                                            '${diaInicioController.text.isNotEmpty ? diaInicioController.text : ""} ${meses[toInt(mesInicioController.text)] ?? ""} - ${diaFinController.text.isNotEmpty ? diaFinController.text : ""} ${meses[toInt(mesFinController.text)] ?? ""} ${anoFinController.text.isNotEmpty ? anoFinController.text : ""}',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: ConstantesColores
                                                    .azul_precio))),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        width: Get.width * 0.8,
                                        height: Get.height * 0.05,
                                        child: RaisedButton(
                                          onPressed: () {
                                            confirmarFiltro();
                                          },
                                          child: Text(
                                            'Filtrar',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          textColor: Colors.white,
                                          color: ConstantesColores.agua_marina,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Positioned(
                            //   top: 230,
                            //   width: 330,
                            //   child: Container(
                            //       margin: EdgeInsets.symmetric(vertical: 20),
                            //       child: Divider(
                            //         thickness: 2,
                            //       )),
                            // ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _dropFecha(String fecha, List<String> list, TextInputType? keyboard,
      TextEditingController controller) {
    print('hola data ${list.toList()}');

    return Obx(() => Container(
          margin: EdgeInsets.only(top: 10),
          width: Get.width * 0.26,
          decoration: BoxDecoration(
            color: HexColor("#E4E3EC"),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropDownCustom(
              value: fecha == 'Dia'
                  ? controlerHistorico.dia.value != '-1'
                      ? controlerHistorico.dia.value
                      : ''
                  : fecha == 'Mes'
                      ? controlerHistorico.mes.value != '-1'
                          ? controlerHistorico.mes.value
                          : ''
                      : controlerHistorico.ano.value != '-1'
                          ? controlerHistorico.ano.value
                          : '',
              hintText: fecha,
              enabled: true,
              keyboard: keyboard,
              textStyle:
                  TextStyle(color: ConstantesColores.azul_precio, fontSize: 15),
              hintStyle: TextStyle(color: ConstantesColores.azul_precio),
              onChanged: (String? newValue) async {
                print('entre vamos bien 2 $newValue');
                if (fecha == 'Dia') {
                  controlerHistorico.dia.value = newValue.toString();
                } else if (fecha == 'Mes') {
                  controlerHistorico.dia.value = '1';
                  controlerHistorico.mes.value = newValue.toString();
                  dropdownItemsDia();
                } else {
                  controlerHistorico.dia.value = '1';
                  controlerHistorico.ano.value = newValue.toString();
                  dropdownItemsDia();
                }
              },
              items: list),
        ));
  }

  Widget inputFecha(
      String placeholder, TextEditingController controller, Function() onTap) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(30),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: Get.width * 0.26,
          height: 50,
          decoration: BoxDecoration(
            color: HexColor("#E4E3EC"),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: controller,
            enabled: false,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.center,
              alignLabelWithHint: true,
              hintText: placeholder,
              hintStyle: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontWeight: FontWeight.bold),
              suffixIcon: Icon(
                Icons.arrow_drop_down_outlined,
                color: HexColor("#41398D"),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(7, 12, 0, 0),
            ),
          ),
        ),
      ),
    );
  }

  cargarFechaInicio() {
    showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: DateTime.now(),
      locale: Locale("es", ""),
      fieldHintText: 'dd/mm/yyyy',
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: HexColor("#E4E3EC"), // header background color
              onPrimary: ConstantesColores.azul_precio, // header text color
              onSurface: ConstantesColores.azul_precio, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: ConstantesColores.agua_marina, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          diaInicioController.text = '${value.day.toString()}';
          mesInicioController.text = '${value.month.toString()}';
          anoInicioController.text = '${value.year.toString()}';
          _selectedDate = value;
        });
      }
    });
  }

  cargarFechaFinal() {
    showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      initialDate: DateTime.now(),
      locale: Locale("es", ""),
      fieldHintText: 'dd/mm/yyyy',
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: HexColor("#E4E3EC"), // header background color
              onPrimary: ConstantesColores.azul_precio, // header text color
              onSurface: ConstantesColores.azul_precio, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: ConstantesColores.agua_marina, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          diaFinController.text = '${value.day.toString()}';
          mesFinController.text = '${value.month.toString()}';
          anoFinController.text = '${value.year.toString()}';
          _selectedDate2 = value;
        });
      }
    });
  }

  confirmarFiltro() {
    if (_selectedDate.toString() != '' &&
        _selectedDate != null &&
        _selectedDate2 != null &&
        _selectedDate2.toString() != '') {
      controlerHistorico.setFechaInicial('${_selectedDate.toString()}');
      controlerHistorico.setFechaFinal('${_selectedDate2.toString()}');
      Navigator.pop(context);
    } else {
      controlerHistorico.setFechaFinal('-1');
      controlerHistorico.setFechaInicial('-1');
      controlerHistorico.setFiltro('-1');
      Navigator.pop(context);
    }
  }

  limpiarFiltro() {
    setState(() {
      controlerHistorico.setFechaFinal('-1');
      controlerHistorico.setFechaInicial('-1');
      controlerHistorico.setFiltro('-1');
      _selectedDate = null;
      _selectedDate2 = null;
      diaInicioController.text = '';
      mesInicioController.text = '';
      anoInicioController.text = '';

      diaFinController.text = '';
      mesFinController.text = '';
      anoFinController.text = '';
    });
  }

  Widget iconLimpiarFiltro() {
    return OutlineButton(
      borderSide: BorderSide(style: BorderStyle.none),
      onPressed: () {
        setState(() {
          limpiarFiltro();
        });
      },
      child: Row(
        children: [
          Icon(
            Icons.cleaning_services_outlined,
            size: 30,
            color: HexColor("#43398E"),
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

  validarInicio() {
    if (controlerHistorico.fechaInicial.value != '-1' ||
        controlerHistorico.fechaFinal.value != '-1') {
      DateTime _fechaInicial =
          DateTime.parse(controlerHistorico.fechaInicial.value);
      DateTime _fechaFinal =
          DateTime.parse(controlerHistorico.fechaFinal.value);

      diaInicioController.text = _fechaInicial.day.toString();
      mesInicioController.text = _fechaInicial.month.toString();
      anoInicioController.text = _fechaInicial.year.toString();

      diaFinController.text = _fechaFinal.day.toString();
      mesFinController.text = _fechaFinal.month.toString();
      anoFinController.text = _fechaFinal.year.toString();
    }
  }

  ///CARGAR ITEMS DORPDOWN
  void dropdownItemsDia() {
    Map<String, int> menuItems = {};
    List<String> list = [];
    // menuItems.addAll({'Dia': -1});

    if (controlerHistorico.mes.value == '2' &&
            controlerHistorico.ano.value == '2024' ||
        controlerHistorico.ano.value == '2028' ||
        controlerHistorico.ano.value == '2032' ||
        controlerHistorico.ano.value == '2036' ||
        controlerHistorico.ano.value == '2040' ||
        controlerHistorico.ano.value == '2044' ||
        controlerHistorico.ano.value == '2048') {
      for (int i = 1; i <= 29; i++) {
        menuItems.addAll({'$i': i});
      }
    } else if (controlerHistorico.mes.value == '2') {
      for (int i = 1; i <= 28; i++) {
        menuItems.addAll({'$i': i});
      }
    } else if (controlerHistorico.mes.value == '4' ||
        controlerHistorico.mes.value == '6' ||
        controlerHistorico.mes.value == '9' ||
        controlerHistorico.mes.value == '11') {
      for (int i = 1; i <= 30; i++) {
        menuItems.addAll({'$i': i});
      }
    } else {
      for (int i = 1; i <= 31; i++) {
        menuItems.addAll({'$i': i});
      }
    }

    menuItems.forEach((key, value) {
      list.add(key);
    });
    setState(() {
      listDias = list;
    });
    // return menuItems;
  }

  ///CARGAR ITEMS DORPDOWN
  void dropdownItemsMes() {
    Map<String, int> menuItems = {};
    List<String> list = [];

    // menuItems.addAll({'Mes': -1});
    menuItems.addAll({'Enero': 1});
    menuItems.addAll({'Febrero': 2});
    menuItems.addAll({'Marzo': 3});
    menuItems.addAll({'Abril': 4});
    menuItems.addAll({'Mayo': 5});
    menuItems.addAll({'Junio': 6});
    menuItems.addAll({'Julio': 7});
    menuItems.addAll({'Agosto': 8});
    menuItems.addAll({'Septiembre': 9});
    menuItems.addAll({'Octubre': 10});
    menuItems.addAll({'Noviembre': 11});
    menuItems.addAll({'Diciembre': 12});

    menuItems.forEach((key, value) {
      list.add(key);
    });

    setState(() {
      listMeses = list;
    });
    // return menuItems;
  }

  ///CARGAR ITEMS DORPDOWN
  void dropdownItemsAno() {
    Map<String, int> menuItems = {};
    List<String> list = [];

    // menuItems.addAll({'Año': -1});

    for (int i = 2022; i <= 2050; i++) {
      menuItems.addAll({'$i': i});
    }

    menuItems.forEach((key, value) {
      list.add(key);
    });
    setState(() {
      listAnos = list;
    });
    // return menuItems;
  }

  @override
  void dispose() {
    diaInicioController.dispose();
    mesInicioController.dispose();
    anoInicioController.dispose();
    super.dispose();
  }
}
