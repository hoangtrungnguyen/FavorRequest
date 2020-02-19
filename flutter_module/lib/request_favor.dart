import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'friend.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import 'mock_values.dart';

class RequestFavorPage extends StatefulWidget {
  List<Friend> friends;

  RequestFavorPage({Key key, this.friends}) : super(key: key);

  @override
  State createState() {
    // TODO: implement createState
    return new RequestFavorPageState();
  }
}

class RequestFavorPageState extends State<RequestFavorPage> {
  final _formKey = GlobalKey<FormState>();
  Friend _selectedFriend;

  static RequestFavorPageState of(BuildContext context) {
    return context.findAncestorStateOfType<RequestFavorPageState>();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "request_favor",
      child: Scaffold(
        appBar: AppBar(
          title: Text("Requesting a favor"),
          leading: CloseButton(),
          actions: <Widget>[
            Builder(
              builder: (context) => FlatButton(
                colorBrightness: Brightness.dark,
                child: Text("SAVE"),
                onPressed: () {
                  RequestFavorPageState.of(context).save();
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Request favor to: "),
                DropdownButtonFormField<Friend>(
                  value: _selectedFriend,
                  onChanged: (friend) {
                    setState(() {
                      _selectedFriend = friend;
                    });
                  },
                  items: widget.friends
                      .map(
                        (f) => DropdownMenuItem<Friend>(
                          value: f,
                          child: Text(f.name),
                        ),
                      )
                      .toList(),
                  validator: (friend) {
                    if (friend == null) {
                      return "You must select a friend to ask the favor";
                    }
                    return null;
                  },
                ),
                Container(
                  height: 16.0,
                ),
                Text("Favor description:"),
                TextFormField(
                  maxLines: 5,
                  inputFormatters: [LengthLimitingTextInputFormatter(200)],
                  validator: (value) {
                    if (value.isEmpty) {
                      return "You must detail the favor";
                    }
                    return null;
                  },
                ),
                Container(
                  height: 16.0,
                ),
                Text("Due Date:"),
                DateTimePickerFormField(
                  inputType: InputType.both,
                  format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                  editable: false,
                  onFieldSubmitted: (date) {},
                  decoration: InputDecoration(
                      labelText: 'Date/Time', hasFloatingPlaceholder: false),
                  validator: (dateTime) {
                    if (dateTime == null) {
                      return "You must select a due date time for the favor";
                    }
                    return null;
                  },
//                onChanged: ,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save() {
    if (_formKey.currentState.validate()) {
      // store the favor request on firebase
      Navigator.pop(context);
    }
  }
}
