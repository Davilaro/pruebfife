import 'package:flutter/material.dart';

import '../../src/preferences/cont_colores.dart';

class RadioButtom extends StatefulWidget {
  final ValueChanged<int>? onChanged;

  RadioButtom({this.onChanged});

  @override
  _RadioButtomState createState() => _RadioButtomState();
}

class _RadioButtomState extends State<RadioButtom> {
  int? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<int>(
          activeColor: ConstantesColores.empodio_verde,
          title: Text('123456'),
          value: 1,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
              widget.onChanged?.call(value!);
            });
          },
        ),
        RadioListTile<int>(
          activeColor: ConstantesColores.empodio_verde,
          title: Text('789101112'),
          value: 2,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
              widget.onChanged?.call(value!);
            });
          },
        ),
        RadioListTile<int>(
          activeColor: ConstantesColores.empodio_verde,
          title: Text('9756335'),
          value: 3,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
              widget.onChanged?.call(value!);
            });
          },
        ),
      ],
    );
  }
}

// class SelectionPage extends StatefulWidget {
//   @override
//   _SelectionPageState createState() => _SelectionPageState();
// }

// class _SelectionPageState extends State<SelectionPage> {
//   int selectedValue = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Radio Selection'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomRadioListTile<int>(
//               value: 1,
//               groupValue: selectedValue,
//               onChanged: (value) {
//                 setState(() {
//                   selectedValue = value;
//                 });
//               },
//               title: 'Opción 1',
//             ),
//             CustomRadioListTile<int>(
//               value: 2,
//               groupValue: selectedValue,
//               onChanged: (value) {
//                 setState(() {
//                   selectedValue = value;
//                 });
//               },
//               title: 'Opción 2',
//             ),
//             CustomRadioListTile<int>(
//               value: 3,
//               groupValue: selectedValue,
//               onChanged: (value) {
//                 setState(() {
//                   selectedValue = value;
//                 });
//               },
//               title: 'Opción 3',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomRadioListTile<T> extends StatelessWidget {
//   final T value;
//   final T groupValue;
//   final ValueChanged<T> onChanged;
//   final String title;

//   CustomRadioListTile({
//     required this.value,
//     required this.groupValue,
//     required this.onChanged,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         unselectedWidgetColor: Colors.grey,
//         radioTheme: RadioThemeData(
//           fillColor: MaterialStateColor.resolveWith((states) {
//             if (states.contains(MaterialState.selected)) {
//               return Colors.blue; // Color de fondo cuando está seleccionado
//             }
//             return Colors.transparent; // Color de fondo cuando no está seleccionado
//           }),
//           overlayColor: MaterialStateColor.resolveWith((states) {
//             if (states.contains(MaterialState.focused)) {
//               return Colors.blue.withOpacity(0.2); // Color de overlay cuando se enfoca
//             }
//             return Colors.transparent;
//           }),
//         ),
//       ),
//       child: RadioListTile<T>(
//         value: value,
//         groupValue: groupValue,
//         onChanged: onChanged,
//         title: Text(title),
//         controlAffinity: ListTileControlAffinity.trailing,
//       ),
//     );
//   }
// }