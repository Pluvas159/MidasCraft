import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:midascraft/navigation/midas_navigator.dart';
import 'package:midascraft/widgets/hlasovanie/hlasovanie.dart';
import 'package:midascraft/widgets/nastavenia/nastavenia.dart';
import 'package:midascraft/util/WebRouteParams.dart';
import 'package:midascraft/util/midas_colors.dart';

import 'forum/forum.dart';

enum DrawerSelection { novinky, hlasovanie, nastavenia, forum}

DrawerSelection _drawerSelection = DrawerSelection.novinky;

class  MidasDrawer extends StatefulWidget {
  const MidasDrawer({Key? key}) : super(key: key);

  @override
  State<MidasDrawer> createState() => _MidasDrawerState();
}

class _MidasDrawerState extends State<MidasDrawer> {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(image: DecorationImage(
                image: ExactAssetImage('assets/midascraft.png'))),

            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                alignment: Alignment.bottomCenter,
                child:
                const Text("MidasCraft", textScaleFactor: 2,
                    style: TextStyle(letterSpacing: 2,
                        decorationStyle: TextDecorationStyle.double,
                        fontWeight: FontWeight.bold)),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: MidasColors.darkRed))),
              ),),),
          ListTile(
            selected: DrawerSelection.novinky == _drawerSelection,
            selectedTileColor: Color(0xff330000),
            title: const Text('Novinky', style: TextStyle(color: Colors.white),),
            onTap: () {
              // Update the state of the app
              setState(() {
                _drawerSelection = DrawerSelection.novinky;
              });
              // Then close the drawer
              Navigator.of(context).pushReplacementNamed(MidasNavigator.route);
            },
          ),
          ListTile(
            selected: DrawerSelection.hlasovanie == _drawerSelection,
            selectedTileColor: Color(0xff330000),
            title: const Text('Hlasovanie', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Update the state of the app
              setState(() {
                _drawerSelection = DrawerSelection.hlasovanie;
              });
              // Then close the drawer
              Navigator.of(context).pushReplacementNamed(Hlasovanie.route);
            },
          ),
          ListTile(
            selected: DrawerSelection.forum == _drawerSelection,
            selectedTileColor: Color(0xff330000),
            title: const Text('F??rum', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Update the state of the app
              setState(() {
                _drawerSelection = DrawerSelection.forum;
              });
              // Then close the drawer
              Navigator.of(context).pushReplacementNamed(Forum.route, arguments: WebRouteParams( "F??rum","https://midascraft.sk/forum/"));
            },
          ),
          ListTile(
            selected: DrawerSelection.nastavenia == _drawerSelection,
            selectedTileColor: Color(0xff330000),
            title: const Text('Nastavenia', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Update the state of the app
              setState(() {
                _drawerSelection = DrawerSelection.nastavenia;
              });
              // Then close the drawer
              Navigator.of(context).pushReplacementNamed(Settings.route);
            },
          ),
        ],
      ),
    );
  }
}