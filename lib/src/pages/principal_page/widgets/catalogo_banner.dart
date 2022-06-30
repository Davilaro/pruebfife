// import 'package:emart/src/preferences/cont_colores.dart';
// import 'package:emart/src/provider/datos_listas_provider.dart';
// import 'package:emart/src/provider/db_provider.dart';
// import 'package:emart/src/utils/firebase_tagueo.dart';
// import 'package:emart/src/widget/acciones_carrito_bart.dart';
// import 'package:emart/src/widget/dounser.dart';
// import 'package:emart/src/widget/filtro_precios.dart';
// import 'package:emart/src/widget/lista_productos_para_catalogo.dart';
// import 'package:emart/src/widget/ofertas_internas.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_uxcam/flutter_uxcam.dart';
// import 'package:get/get.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:provider/provider.dart';

// class CatalogoBanner extends StatefulWidget {
//   final String codCategoria;
//   final String numEmpresa;
//   final int tipoCategoria;
//   final String nombreCategoria;
//   final String img;

//   const CatalogoBanner(
//       {Key? key,
//       required this.codCategoria,
//       required this.numEmpresa,
//       required this.tipoCategoria,
//       required this.nombreCategoria,
//       required this.img})
//       : super(key: key);

//   @override
//   State<CatalogoBanner> createState() => _CatalogoBannerState();
// }

// class _CatalogoBannerState extends State<CatalogoBanner> {
//   final TextEditingController _controllerUser = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     //Se define el nombre de la pantalla para UXCAM
//     FlutterUxcam.tagScreenName('${widget.nombreCategoria}Page');
//     final providerDatos = Provider.of<DatosListas>(context);
//     final Debouncer onSearchDebouncer =
//         new Debouncer(delay: new Duration(milliseconds: 500));

//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: ConstantesColores.color_fondo_gris,
//       appBar: AppBar(
//         leading: new IconButton(
//           icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           '${widget.nombreCategoria}',
//           style: TextStyle(color: HexColor("#41398D")),
//         ),
//         elevation: 0,
//         actions: <Widget>[
//           AccionesBartCarrito(esCarrito: false),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//                 height: size.height * 0.1,
//                 width: size.width * 1,
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buscador(context, onSearchDebouncer),
//                       GestureDetector(
//                         onTap: () => {_irFiltro()},
//                         child: Container(
//                           margin: EdgeInsets.only(right: 30, bottom: 10),
//                           child: GestureDetector(
//                             child: SvgPicture.asset('assets/filtro_btn.svg'),
//                           ),
//                         ),
//                       )
//                     ])),
//             Container(
//                 padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
//                 height: size.height * 0.2,
//                 width: double.infinity,
//                 child: OfertasInterna(nombreFabricante: widget.codCategoria)),
//             Container(
//               height: Get.height * 0.62,
//               width: size.width * 1,
//               padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
//               child: FutureBuilder(
//                   initialData: [],
//                   //SE VA DESCARGAR POR DB
//                   future: DBProvider.db.cargarProductos(
//                       widget.codCategoria,
//                       widget.tipoCategoria,
//                       _controllerUser.text,
//                       providerDatos.getPrecioMinimo,
//                       providerDatos.getPrecioMaximo),
//                   builder:
//                       (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                     if (!snapshot.hasData) {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     } else {
//                       return ListaProductosCatalogo(
//                           data: snapshot.data,
//                           numEmpresa: widget.numEmpresa,
//                           cantidadFilas: 2,
//                           location: widget.nombreCategoria);
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _buscador(BuildContext context, Debouncer onSearchDebouncer) {
//     return Container(
//       margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
//       padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//       width: MediaQuery.of(context).size.width * 0.75,
//       decoration: BoxDecoration(
//         color: HexColor("#E4E3EC"),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: TextField(
//           controller: _controllerUser,
//           style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
//           decoration: InputDecoration(
//             fillColor: HexColor("#41398D"),
//             hintText: 'Encuentra tus productos',
//             hintStyle: TextStyle(
//               color: HexColor("#41398D"),
//             ),
//             suffixIcon: Padding(
//               padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//               child: Icon(
//                 Icons.search,
//                 color: HexColor("#41398D"),
//               ),
//             ),
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
//           ),
//           onChanged: (val) => onSearchDebouncer.debounce(() {
//                 if (val.length > 3) {
//                   TagueoFirebase().sendAnalityticsSearch(val);
//                 }
//                 setState(() {});
//               })),
//     );
//   }

//   _irFiltro() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => FiltroPrecios()),
//     );
//   }
// }
