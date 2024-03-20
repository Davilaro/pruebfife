import 'package:emart/_pideky/presentation/my_statistics/view/widgets/circulo_posicion_empodio.dart';
import 'package:flutter/cupertino.dart';

class Empodio extends StatelessWidget {
  final List lista;
  final String tipo;
  final List? imgSubCategoria;
  Empodio(
      {Key? key, required this.lista, required this.tipo, this.imgSubCategoria})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: CirculoPosicionEmpodio(
                item: lista[1],
                posicion: '2',
                tipo: tipo,
                imgSubCategoria: imgSubCategoria![1]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CirculoPosicionEmpodio(
                item: lista[0],
                posicion: '1',
                tipo: tipo,
                imgSubCategoria: imgSubCategoria![0]),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: CirculoPosicionEmpodio(
                  item: lista[2],
                  posicion: '3',
                  tipo: tipo,
                  imgSubCategoria: imgSubCategoria![2]))
        ],
      ),
    );
  }
}
