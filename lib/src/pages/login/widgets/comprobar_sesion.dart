import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter/material.dart';

final prefs = new Preferencias();

class ComprobarSesion extends StatefulWidget {
  @override
  State<ComprobarSesion> createState() => _ComprobarSesionState();
}

class _ComprobarSesionState extends State<ComprobarSesion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _pasarModulo(),
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                  ));
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center();
                  }
              }
            }));
  }

  Future _pasarModulo() async {
    if (prefs.codClienteLogueado != null) {
      Navigator.pushReplacementNamed(
        context,
        'tab_opciones',
      );
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
