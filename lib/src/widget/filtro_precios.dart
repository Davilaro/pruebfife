import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/pages/catalogo/widgets/sliderPrecios.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

var providerDatos = new DatosListas();

class FiltroPrecios extends StatefulWidget {
  final String? codMarca;
  final String? nombreMarca;
  final String? urlImagen;
  FiltroPrecios(
      {Key? key,
      required this.codMarca,
      required this.nombreMarca,
      required this.urlImagen})
      : super(key: key);

  @override
  _FiltroPreciosState createState() => _FiltroPreciosState();
}

class _FiltroPreciosState extends State<FiltroPrecios> {
  ControllerProductos catalogSearchViewModel = Get.find();
  RangeValues values = RangeValues(0, 500000);
  int valorRound = 3;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final providerDatos = Provider.of<DatosListas>(context);
    final controlador = Get.find<ControlBaseDatos>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Producto',
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: HexColor("#30C3A3"),
            ),
            onPressed: () {
              controlador.isDisponibleFiltro.value = true;
              Navigator.pop(context);
              catalogSearchViewModel.setPrecioMinimo(0);
              catalogSearchViewModel.setPrecioMaximo(1000000000);
            }),
        actions: <Widget>[
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: size.height * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(25.0),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text("Mejora tu búsqueda",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: HexColor("#41398D")),
                        textAlign: TextAlign.left),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.cancel_outlined,
                        color: ConstantesColores.agua_marina,
                        size: Get.height * 0.04,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(5.0),
                child: Text("Ofertas y promociones",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#41398D")),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () => {
                            if (valorRound == 1)
                              {_cambiarValor(3)}
                            else
                              {_cambiarValor(1)}
                          },
                      child: valorRound == 2
                          ? Icon(
                              Icons.brightness_1_outlined,
                              color: HexColor("#41398D"),
                            )
                          : valorRound == 3
                              ? Icon(
                                  Icons.brightness_1_outlined,
                                  color: HexColor("#41398D"),
                                )
                              : Icon(
                                  Icons.task_alt_outlined,
                                  color: HexColor("#30C3A3"),
                                )),
                  SizedBox(width: 10),
                  Text("Producto del día",
                      style: TextStyle(color: HexColor("#41398D")))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => {
                      if (valorRound == 2)
                        {_cambiarValor(3)}
                      else
                        {_cambiarValor(2)}
                    },
                    child: valorRound == 1
                        ? Icon(
                            Icons.brightness_1_outlined,
                            color: HexColor("#41398D"),
                          )
                        : valorRound == 3
                            ? Icon(Icons.brightness_1_outlined,
                                color: HexColor("#41398D"))
                            : Icon(
                                Icons.task_alt_outlined,
                                color: HexColor("#30C3A3"),
                              ),
                  ),
                  SizedBox(width: 10),
                  Text("Producto más vendidos",
                      style: TextStyle(color: HexColor("#41398D")))
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(5.0),
                child: Text("Rango de precios",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#41398D")),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 20,
              ),
              SliderPrecios(
                values: values,
                onChange: (() => {this.values = values}),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  controlador.isDisponibleFiltro.value = false;
                  await _cargarPrecios(values, providerDatos);
                },
                child: Container(
                  width: size.width * 0.9,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ConstantesColores.agua_marina,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Filtrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _cambiarValor(int i) {
    setState(() {
      valorRound = i;
    });
  }

  _cargarPrecios(RangeValues values, providerDatos) async {
    String? codigoMarca =
        await DBProvider.db.consultarCodigoMarcaPorNombre(widget.nombreMarca);
    if (valorRound == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    numEmpresa: 'nutresa',
                    nombreCategoria: "Producto más vendidos",
                    tipoCategoria: 7,
                    img: widget.urlImagen,
                    claseProducto: 7,
                    isActiveBanner: false,
                    codigoMarca: codigoMarca,
                    locacionFiltro: "categoria",
                    codigoProveedor: "",
                  )));
    }
    if (valorRound == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    numEmpresa: 'nutresa',
                    nombreCategoria: "Producto del día",
                    tipoCategoria: 6,
                    img: widget.urlImagen,
                    claseProducto: 6,
                    isActiveBanner: false,
                    locacionFiltro: "categoria",
                    codigoMarca: codigoMarca,
                    codigoProveedor: "",
                  )));
    }
    if (valorRound == 3) {
      String? codigo =
          await DBProvider.db.consultarCodigoMarcaPorNombre(widget.nombreMarca);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: widget.codMarca,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 3,
                    nombreCategoria: widget.nombreMarca,
                    claseProducto: 4,
                    codigoMarca: codigo,
                    isActiveBanner: false,
                    locacionFiltro: "proveedor",
                    codigoProveedor: "",
                  )));
    }
  }
}
