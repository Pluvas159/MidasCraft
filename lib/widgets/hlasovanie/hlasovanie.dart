
import 'package:midascraft/util/WebRouteParams.dart';
import 'package:html/dom.dart' as dom;

import 'package:flutter/material.dart';
import 'package:midascraft/util/midas_colors.dart';

import '../loading/loading.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        body: Column(children: <Widget>[nameForm(), hlasovanieOptions()]),
    );
  }

  Widget nameForm() {
    return Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: MidasColors.darkRed))),
        margin: EdgeInsets.all(32),
        child: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            floatingLabelStyle: TextStyle(color: Colors.white10),
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

class HlasovanieDropDown extends StatefulWidget {  @override
  State<HlasovanieDropDown> createState() => HlasovanieDropDownState();


}

class HlasovanieDropDownState extends State<HlasovanieDropDown>{
  String dropdownValue = "Two" ;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: MidasColors.darkRed,
      alignment: Alignment.center,
      underline: Divider(color: MidasColors.darkRed),
      items: <String>['Mesačné štatistiky', 'Two', 'Free', 'Four']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value, textScaleFactor: 2, textAlign: TextAlign.center),
      );
    }).toList(), value: dropdownValue, onChanged: (value) { setState(() {
      dropdownValue = value!;
    });},
  );}
}


