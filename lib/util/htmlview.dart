import 'package:flutter_html/flutter_html.dart' as fhtml;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:midascraft/util/WebRouteParams.dart';
import 'package:html/parser.dart' as parser;
import 'package:midascraft/util/midas_colors.dart';
import 'package:midascraft/util/webview.dart';



class HtmlView extends StatefulWidget {
  const HtmlView({Key? key}) : super(key: key);
  static const route = "/view/html";

  @override
  State<HtmlView> createState() => HtmlViewState();
}

class HtmlViewState extends State<HtmlView> {
  dom.Document page = dom.Document();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getPage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Params = ModalRoute.of(context)!.settings.arguments as WebRouteParams;
    if (page.hasContent()) {
      switch (Params.type) {
        case "article":
          return widgetArticle(context, Params, page);
        default:
          return Scaffold(
              appBar: AppBar(
                title: Text(Params.title),
                backgroundColor: MidasColors.veryDarkRed,
              ),
              body: SingleChildScrollView(
                  child: fhtml.Html(
                data: page.getElementsByClassName("entry-content")[0].outerHtml,
                tagsList: fhtml.Html.tags..addAll(["bird", "flutter"]),
                onLinkTap: (url, _, __, ___) {
                  Navigator.of(context).pushNamed("/",
                      arguments: WebRouteParams("MidasCraft", url!));
                },
                style: {
                  "strong": fhtml.Style(color: Colors.white),
                  "li": fhtml.Style(margin: EdgeInsets.all(4)),
                  "p": fhtml.Style(margin: EdgeInsets.all(8)),
                },
              )));
      }
    } else {
      return Scaffold(
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
  }

  _getPage(context) async {
    final Params = ModalRoute.of(context)!.settings.arguments as WebRouteParams;
    var html = await http.get(Uri.parse(Params.url));
    setState(() {
      page = parser.parse(html.body);
    });
  }
}

/*Widget article(BuildContext context, WebRouteParams Params, dom.Document page) {
  dom.Document newPage = page.clone(true);
  newPage.getElementsByTagName("figure")[0].remove();
  dom.Document pageFooter = dom.Document();
  for ( var i = 0; i<5; i++) {
    newPage.getElementsByClassName("sharedaddy")[0].previousElementSibling!
        .remove();
  }
  newPage.getElementsByClassName("sharedaddy")[0].remove();

  YoutubePlayerController _controller = YoutubePlayerController(initialVideoId: '7D09rF0SnFA', params: const YoutubePlayerParams(
    showControls: true,
    autoPlay: false,
    mute: false,
  ),);
  return Scaffold(
      appBar: AppBar(
        title: Text(Params.title),
        backgroundColor: Color(0xff330000),
      ),
      body: ListView(

          children: [
            Image.network(page
                .getElementsByClassName("entry-thumbnail")[0]
                .children[0]
                .attributes["src"]
                .toString()),
            fhtml.Html(
              data: newPage.getElementsByClassName("entry-content")[0].outerHtml,
              tagsList: fhtml.Html.tags..addAll(["bird", "flutter"]),
              onLinkTap: (url, _, __, ___) {
                Navigator.of(context).pushNamed(MidasWebView.route,
                    arguments: WebRouteParams("MidasCraft", url!));
              },
              style: {
                "strong": fhtml.Style(color: Colors.white),
                "li": fhtml.Style(margin: EdgeInsets.all(4)),
                "p": fhtml.Style(
                  margin: EdgeInsets.all(15),
                ),
                "a": fhtml.Style(
                    color: Colors.red
                )
              },
            )
            , YoutubePlayerIFrame(
              controller: _controller,
              aspectRatio: 16/9,
            ) ])
  )
  ;
}
*/

Widget widgetArticle(BuildContext context, WebRouteParams Params, dom.Document page) {
  dom.Document newPage = page.clone(true);
  newPage.getElementsByTagName("figure")[0].remove();
  newPage.getElementsByClassName("sharedaddy")[0].remove();
  newPage.getElementById("toc_container")?.remove() ;


  return Scaffold(
      appBar: AppBar(
        title: Text(Params.title),
        backgroundColor: Color(0xff330000),
      ),
      body: ListView(
          children: [
            Image.network(page
                .getElementsByClassName("entry-thumbnail")[0]
                .children[0]
                .attributes["src"]
                .toString()),
            Divider(),
            HtmlWidget(
              newPage.getElementsByTagName("article")[0].outerHtml,
              onTapUrl: (url) {
                Navigator.of(context).pushNamed(MidasWebView.route,
                    arguments: WebRouteParams("MidasCraft", url));
                return true;
              },
                webView: true,
              customStylesBuilder: (element) {
                switch(element.localName){
                  case "p":
                    return { "margin" : "20px" };
                  case "strong":
                    return { "color" : "white" };
                  default:
                     if(element.localName!.contains("h")){
                        return { "margin" : "10px", "color": "white" };
                }

                }
                return null;
            }
            )
          ])
  )
  ;
}
