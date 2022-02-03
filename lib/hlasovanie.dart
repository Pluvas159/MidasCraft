
import 'package:midascraft/notifications/notifications_api.dart';
import 'package:midascraft/util/WebRouteParams.dart';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

import 'drawer.dart';
import 'loading.dart';

class Hlasovanie extends StatefulWidget {
  const Hlasovanie({Key? key}) : super(key: key);

  static const String route = "/hlasovanie";


  @override
  State<Hlasovanie> createState() => _HlasovanieState();
}

class _HlasovanieState extends State<Hlasovanie> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  final List<dom.Element?> _voteForms = [
    LoadState.getDocument().getElementsByClassName("wvote")[0].parent,
    LoadState.getDocument().getElementsByClassName("wvote2")[0].parent,
    LoadState.getDocument().getElementsByClassName("wvote3")[0].parent
  ];
  List<String> voteFormsImages = ["assets/hlasovanie/czechcraft.png", "assets/hlasovanie/craftlist.png", "assets/hlasovanie/minecraft-server.png"];
  List<String> voteFormsUris = [];
  List<String> voteFormsQueryParams = ["user", "nickname", "nick"];


  String name = "";
  final nameController = TextEditingController(text: LoadState.prefs.getString('voteName') ?? "");

  bool webOpened = false;

  @override
  void initState() {
    voteFormsUris = getFormUris();

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
        key: _key,
        appBar: AppBar(
          title: const Text('Hlasovanie za MidasCraft'),
          backgroundColor: Color(0xff330000),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/midascraft.png",
            ),
          ),
        ),
        body: Column(children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                 border: Border(bottom: BorderSide(color: Colors.red))),
              margin: EdgeInsets.all(32),
              child: TextField(
                controller: nameController,
                decoration:  const InputDecoration(
                  floatingLabelStyle: TextStyle(color: Colors.red),
                  labelStyle: TextStyle(color: Colors.white),
                  border:  UnderlineInputBorder(),
                  labelText: "Prezývka",
                ),

          )),
          IconButton(icon: Icon(Icons.assignment_turned_in), onPressed: () => LoadState.notifications.send_notification("MidasCraft", "Hlasovanie") ,),
          Expanded (
              child: ListView.builder(

              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    child: Image.asset(voteFormsImages[index]),
                    onTap: () {
                      Navigator.of(context).pushNamed("/view", arguments: WebRouteParams("Hlasovanie", voteFormsUris[index] + '?'+ voteFormsQueryParams[index]+ '=' + nameController.text));
                          //_launchURL(voteFormsUris[index] + '?'+ voteFormsQueryParams[index]+ '=' + nameController.text);
                          //MidasWebView(url: voteFormsUris[index] + '?'+ voteFormsQueryParams[index]+ '=' + nameController.text);
                    });
              }))
        ]),
        endDrawer: MidasDrawer());
  }


  List<String> getFormUris() {
    List<String> formUris = [];
    for (var el in _voteForms) {
      formUris.add(el!.attributes['action'].toString());
    }

    return formUris;
  }
}
