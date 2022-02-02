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
  bool nameSave = false;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 50, 0),
              child: Text(
                "Automatická prezývka pre hlasovanie: ",
                textAlign: TextAlign.left,
                textScaleFactor: 1.1,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                            onChanged: (text) {
                              setState(() {
                                nameSave = false;
                              });
                            },
                            controller: nameController,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              floatingLabelStyle: TextStyle(color: Colors.red),
                              labelStyle: TextStyle(color: Colors.white),

                            ))),
                    IconButton(
                        onPressed: () {
                          if (nameController.text !=
                              LoadState.prefs.getString("voteName")) {
                            LoadState.prefs
                                .setString("voteName", nameController.text);
                            setState(() {
                              nameSave = true;
                            });
                          }
                        },
                        icon: Icon(Icons.save,
                            color: nameSave ? Colors.red : Colors.white))
                  ],
                )
              ])),
        ],
      ),
      endDrawer: MidasDrawer(),
    );
  }
}
