import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:midascraft/notifications/notifications_api.dart';
import 'package:midascraft/util/WebRouteParams.dart';
import 'package:http/http.dart' as http;

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:midascraft/util/midas_colors.dart';

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
  List<String> voteFormsImages = [
    "assets/hlasovanie/czechcraft.png",
    "assets/hlasovanie/craftlist.png",
    "assets/hlasovanie/minecraft-server.png"
  ];
  List<String> voteFormsUris = [];
  List<String> voteFormsQueryParams = ["user", "nickname", "nick"];

  List<dom.Element> statistiky = [];

  String name = "";
  final nameController =
      TextEditingController(text: LoadState.prefs.getString('voteName') ?? "");

  bool webOpened = false;

  @override
  void initState() {
    voteFormsUris = getFormUris();
    getStatistiky();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  getStatistiky() async {
    final response = await http.get(Uri.parse(
        "https://midascraft.sk/zoznam-hlasujucich-za-aktualny-mesiac/"));
    dom.Document document = parser.parse(response.body);
    setState(() {
      statistiky =
          document.getElementsByTagName("table")[1].getElementsByTagName("tr");
    });
  }

  Widget hlasovanieOptions() {
    return Expanded(
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  child: Image.asset(voteFormsImages[index]),
                  onTap: () {
                    Navigator.of(context).pushNamed("/view",
                        arguments: WebRouteParams(
                            "Hlasovanie",
                            voteFormsUris[index] +
                                '?' +
                                voteFormsQueryParams[index] +
                                '=' +
                                nameController.text));
                    //_launchURL(voteFormsUris[index] + '?'+ voteFormsQueryParams[index]+ '=' + nameController.text);
                    //MidasWebView(url: voteFormsUris[index] + '?'+ voteFormsQueryParams[index]+ '=' + nameController.text);
                  });
            }));
  }

  Widget HlasovaniePages() {
    final PageController ctrl = PageController(initialPage: 0);

    return PageView(controller: ctrl, children: [
      Column(children: <Widget>[nameForm(), hlasovanieOptions()]),
      Container(
          child: statistiky.isNotEmpty
              ? Column(children: [
                  Container(
                    color: Colors.white10,
                    padding: EdgeInsets.symmetric(vertical: 20),
                      child:
                        Text(
                      "Štatistiky hlasovania",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.5,
                          style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(child: ListView.builder(
                    itemCount: statistiky.length - 1,
                    itemBuilder: (BuildContext context, int index) {
                      List<dom.Element> row =
                          statistiky[index + 1].getElementsByTagName("td");
                      return Column(children: <Widget>[
                        ListTile(
                          title: Text(row[0].text +
                              row[1].getElementsByTagName("b")[0]!.text),
                          leading: Image.network(row[1]
                              .getElementsByTagName("img")[0]
                              .attributes["src"]
                              .toString()),
                          trailing: Text(
                            row[2].text,
                            textScaleFactor: 2,
                            style: TextStyle(color: MidasColors.darkRed),
                          ),
                        ),
                        Divider(
                          color: MidasColors.darkRed,
                        )
                      ]);
                    },
                  ))
                ])
              : CircularProgressIndicator()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: HlasovaniePages(),
        endDrawer: MidasDrawer());
  }

  Widget nameForm() {
    return Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.red))),
        margin: EdgeInsets.all(32),
        child: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            floatingLabelStyle: TextStyle(color: Colors.red),
            labelStyle: TextStyle(color: Colors.white),
            border: UnderlineInputBorder(),
            labelText: "Prezývka",
          ),
        ));
  }

  List<String> getFormUris() {
    List<String> formUris = [];
    for (var el in _voteForms) {
      formUris.add(el!.attributes['action'].toString());
    }

    return formUris;
  }
}
