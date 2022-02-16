import 'package:flutter/material.dart';
import 'package:midascraft/util/midas_colors.dart';
import 'package:midascraft/widgets/hlasovanie/celkove_hlasovania.dart';
import 'package:midascraft/widgets/hlasovanie/mesacne_hlasovania.dart';
import 'package:midascraft/widgets/hlasovanie/hlasovanie.dart';

import 'hlasovanie.dart';


enum DrawerSelection { mesacne, celkove }


class HlasovanieDrawer extends StatefulWidget {
  const HlasovanieDrawer({Key? key}) : super(key: key);
  
  @override
  State<HlasovanieDrawer> createState() => HlasovanieDrawerState();

      
}

class HlasovanieDrawerState extends State<HlasovanieDrawer> {

  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Hlasovanie(),
    MesacneHlasovanie(),
    CelkoveHlasovania()
  ];

  static final List<String> _drawerTitles = <String>[
    "Hlasovanie za MidasCraft",
    "Mesačné hlasovania",
    "Celkové hlasovania"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_drawerTitles[_selectedIndex]),
          backgroundColor: Color(0xff330000),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/midascraft.png",
            ),
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        endDrawer: Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Hlasovanie"),
            selected: _selectedIndex == 0,
            selectedTileColor: MidasColors.veryDarkRed,
            selectedColor: Colors.white,
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Mesačné hlasy"),
            selected: _selectedIndex == 1,
            selectedTileColor: MidasColors.veryDarkRed,
            selectedColor: Colors.white,
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pop(context);
              },
          ),
          ListTile(
            title: Text("Celkové hlasy"),
            selected: _selectedIndex == 2,
            selectedTileColor: MidasColors.veryDarkRed,
            selectedColor: Colors.white,
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              Navigator.pop(context);
            },
          )
        ],
      )
    ));
  }
  
  
}