import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midascraft/util/midas_colors.dart';

import '../loading/loading.dart';

class Nastavenia extends StatefulWidget {
  static final String route = "/nastavenia";

  static String voteUsername = "";

  @override
  State<Nastavenia> createState() => _NastaveniaState();
}

class _NastaveniaState extends State<Nastavenia> {
  final nameController =
      TextEditingController(text: LoadState.prefs.getString('voteName') ?? "");
  bool nameSave = false;
  bool notificationState =
      LoadState.prefs.getBool("notificationState") ?? false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  Widget notificationSwitch() {
    return SwitchOption("Notifikácie hlasovania", Switch(activeColor: MidasColors.red, value: notificationState, onChanged:(state) {
      setState(() {
        LoadState.prefs.setBool("notificationState", state);
        notificationState = state;
      });
    } )
    );
  }

  Widget SwitchOption(String text, Switch sw) {
    return Container(
        child: Row(children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Text(
                text,
                textAlign: TextAlign.left,
                textScaleFactor: 1.1,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MidasColors.darkRed),
              )),
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: 50),

                  alignment: Alignment.bottomRight,
                  child: sw,
    ))]));
  }


  Widget nameChange() {
    return Padding(
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
        ]));
  }

  Widget nastaveniaText(String text) {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 20, 50, 0),
        child: Text(
          text,
          textAlign: TextAlign.left,
          textScaleFactor: 1.1,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: MidasColors.darkRed),
        ));
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
          nastaveniaText("Automatická prezývka pre hlasovanie: "),
          nameChange(),
          notificationSwitch()
        ],
      ),
    );
  }
}
