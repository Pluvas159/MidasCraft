import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:midascraft/drawer.dart';
import 'package:midascraft/util/WebRouteParams.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class Forum extends StatefulWidget {
  const Forum({Key? key}) : super(key: key);
  static const route = "/forum";

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> with SingleTickerProviderStateMixin {
  dom.Document page = dom.Document();
  late final Params;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _getPage(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Params = ModalRoute
        .of(context)!
        .settings
        .arguments as WebRouteParams;

    return page.hasContent() ?
      Scaffold(
      appBar: AppBar(
        title: Text(Params.title),
        backgroundColor: Color(0xff330000),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/midascraft.png",
          ),
        ),
      ),
      body: HtmlWidget(
        page.getElementById("main-content")!.innerHtml
      ),
      endDrawer: MidasDrawer(),
    ) : Scaffold(
        body: Center(
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                  const Image(image: AssetImage('assets/midascraft.png'), height: 150, alignment: Alignment.center,),
                  Text("MidasCraft", style: const TextTheme().headline1, textScaleFactor: 2,),
                  Divider(height: 400, color: const ColorScheme.dark().background,),
                  const CircularProgressIndicator(color: Colors.red,),
                ]
            )
        )
    );

  }

  _getPage(context) async {
    final _Params = ModalRoute
        .of(context)!
        .settings
        .arguments as WebRouteParams;
    var response = await http.get(Uri.parse(_Params.url));
    setState(() {
      page = parser.parse(response.body);
    });

  }
}
