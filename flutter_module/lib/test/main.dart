import 'package:flutter/material.dart';
import 'package:flutter_module/test/verification_code_input_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: _formSignUp(),
    );
  }
}

class _formSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form sign up"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[VerificationCodeFormField(
            )],
          ),
        ),
      ),
    );
  }
}
