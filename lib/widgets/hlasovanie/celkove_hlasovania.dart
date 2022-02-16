import 'package:flutter/material.dart';
import 'package:midascraft/util/midas_colors.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;


class CelkoveHlasovania extends StatefulWidget{

  @override
  State<CelkoveHlasovania> createState() => CelkoveHlasovaniaState();
}


class CelkoveHlasovaniaState extends State<CelkoveHlasovania> {

  List<dom.Element> statistiky = [];

  @override
  void initState() {
    getStatistiky();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Container(
        child: statistiky.isNotEmpty
            ? Column(children: [
          Expanded(child: ListView.builder(
            itemCount: statistiky.length - 1,
            itemBuilder: (BuildContext context, int index) {
              List<dom.Element> row =
              statistiky[index + 1].getElementsByTagName("td");
              return Column(children: <Widget>[
                ListTile(
                  title: Text(row[0].text +
                      row[1].getElementsByTagName("b")[0].text),
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
            : Center(child: CircularProgressIndicator()));
  }

  getStatistiky() async {
    final response = await http.get(Uri.parse(
        "https://midascraft.sk/zoznam-hlasujucich/"));
    dom.Document document = parser.parse(response.body);
    setState(() {
      statistiky =
          document.getElementsByTagName("table")[1].getElementsByTagName("tr");
    });
  }

}