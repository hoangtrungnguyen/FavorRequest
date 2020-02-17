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

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
        color: Colors.blue,
        home: Builder(
//          key: _navigatorKey,
          builder: (context) => _screen1(context),
        ),
        pageRouteBuilder:
            <Void>(RouteSettings settings, WidgetBuilder builder) {
          return MaterialPageRoute(builder: builder, settings: settings);
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
            RaisedButton(
              child: Text("Go to screen 2 !!"),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return _screen2(context);
                }));
              },
            )
          ],
        ));
  }

  Widget _screen2(BuildContext context) {
    return Container(
        color: Colors.lightBlue,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Screen 2"),
            RaisedButton(
              child: Text("Go back !!"),
              onPressed: () {
                Navigator.of(context).pop();
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
