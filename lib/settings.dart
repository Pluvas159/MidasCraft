import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midascraft/drawer.dart';

import 'loading.dart';

class Settings extends StatefulWidget {
  static final String route = "/nastavenia";

  static String voteUsername = "";

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final nameController =
      TextEditingController(text: LoadState.prefs.getString('voteName') ?? "");


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nastavenia"),
        backgroundColor: Color(0xff330000),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/midascraft.png",
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(50),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(color: Colors.red),
                            labelStyle: TextStyle(color: Colors.white),
                            border: UnderlineInputBorder(),
                            labelText: "Prezývka",
                          ))),
                  IconButton(
                      onPressed: () {
                        LoadState.prefs
                            .setString("voteName", nameController.text);
                      },
                      icon: Icon(Icons.save, color: Colors.white))
                ],
              )),

        ],
      ),
      endDrawer: MidasDrawer(),
    );
  }
}
