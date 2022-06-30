import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter/material.dart';


final prefs = new Preferencias();

class Drawable extends StatefulWidget {
 
  const Drawable({Key? key}) : super(key: key);

  @override
  State<Drawable> createState() => _DrawableState();
}

class _DrawableState extends State<Drawable> {
  @override
  Widget build(BuildContext context) {

    
    var myColour;
    return ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Color(int.parse('${prefs.colorThema}')),
          ),
          accountName: Padding(
            child: Row(
              children: <Widget>[
                Text("Emart"),
              ],
            ),
            padding: EdgeInsets.only(top: 10),
          ),
          accountEmail: Text("  "),
          currentAccountPicture: CircleAvatar(
            backgroundColor:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? myColour
                    : Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),
        ),
        ListTile(
          title: const Text('Item 1'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: const Text('Item 2'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
      ],
    );
  }
}