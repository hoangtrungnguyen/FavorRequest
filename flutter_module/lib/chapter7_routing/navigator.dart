import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(NavigatorDirectApp());

class NavigatorDirectApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavigatorDirectAppState();
  }
}

class NavigatorDirectAppState extends State<NavigatorDirectApp>
    with WidgetsBindingObserver {
  String _message = "";

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
        color: Colors.blue,
//        onGenerateRoute: (settings) {
//          if (settings.name == '/') {
//            return MaterialPageRoute(builder: (context) => _screen1(context));
//          } else if (settings.name == '/2') {
//            return MaterialPageRoute(
//                builder: (context) =>
//                    _screen2(context, arg: settings.arguments));
//          }
//        },
        routes: {
          '/': (context) => _screen1(context),
          '/2': (context) => _screen2(context),
        },
        pageRouteBuilder:
            <Void>(RouteSettings settings, WidgetBuilder builder) {
          return PageRouteBuilder(
              transitionsBuilder: (BuildContext context, animation,
                  secondaryAnimation, widget) {
                return new SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(-1.0, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: widget,
                );
              },
              settings: settings,
              pageBuilder: (BuildContext context, _, __) => builder(context));
        });
  }

  Widget _screen1(BuildContext context) {
    return Container(
        color: Colors.orangeAccent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Screen 1"),
            Container(
              height: 16.0,
            ),
            Text("${_message}"),
            RaisedButton(
              child: Text("Go to screen 2 !!"),
              onPressed: () async {
//                Navigator.of(context)
//                    .push(MaterialPageRoute(builder: (BuildContext context) {
//                  return _screen2(context);
//                }
//                ));
                final message = await Navigator.of(context).pushNamed('/2',
                        arguments: "Hello: ${WordPair.random()}") ??
                    "Came back from button";
                setState(() {
                  _message = message;
                });
//                Navigator.of(context)
//                    .pushNamed('/2', arguments: "Hello: ${WordPair.random()}");
              },
            )
          ],
        ));
  }

  Widget _screen2(BuildContext bContext, {String arg = ""}) {
    return Container(
        color: Colors.lightBlue,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Screen 2",
              style: Theme.of(bContext).textTheme.display1,
            ),
            Container(
              height: 16.0,
            ),
            Text(
              "Message from screen1 \n ${arg}",
              style: Theme.of(bContext).textTheme.body1.copyWith(
                    color: Colors.white,
                  ),
            ),
            Container(
              height: 16.0,
            ),
            RaisedButton(
              child: Text("Go back !!"),
              onPressed: () {
                Navigator.of(bContext)
                    .pop("Good bye message: ${WordPair.random()}");
              },
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
