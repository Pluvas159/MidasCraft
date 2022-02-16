import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midascraft/widgets/hlasovanie/hlasovanie_navigator.dart';
import 'package:midascraft/widgets/nastavenia/nastavenia.dart';
import 'package:midascraft/util/midas_colors.dart';
import 'package:midascraft/widgets/novinky/novinky.dart';

class MidasNavigator extends StatefulWidget {
  const MidasNavigator({Key? key}) : super(key: key);
  static const route = '/midas';

  @override
  State<MidasNavigator> createState() => _MidasNavigatorState();
}

class _MidasNavigatorState extends State<MidasNavigator> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Novinky(),
    HlasovanieDrawer(),
    Nastavenia(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Novinky',
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_turned_in),
              label: 'Hlasovanie'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Nastavenia'),

        ],
      backgroundColor: MidasColors.veryDarkRed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,

    )
    );
  }
  
}