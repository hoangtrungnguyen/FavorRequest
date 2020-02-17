import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_module/favor.dart';
import 'package:flutter_module/mock_values.dart';
import 'package:flutter_module/request_favor.dart';
import 'package:flutter_module/theme.dart';
import 'package:intl/intl.dart';

const kFavorMaxWidth = 450.0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isAndroid = Platform.isAndroid;
    if (Platform.isIOS) {
      return CupertinoApp(
//        theme: lightCupertinoTheme,
        home: FavorsPage(),
      );
    }
    return MaterialApp(
      theme: isAndroid ? lightTheme : cupertinoLightTheme,
      title: 'Flutter Demo',
//      home: RequestFavorPage(
//        // uncomment this and comment 'home' below to change the visible page for now
//        friends: mockFriends,
//      ),
      home: FavorsPage(),
    );
  }
}

class FavorsPage extends StatefulWidget {
  // using mock values from mock_favors dart file for now

  @override
  State<StatefulWidget> createState() => FavorsPageState();
}

class FavorsPageState extends State<FavorsPage> {
  List<Favor> pendingAnswerFavors;
  List<Favor> acceptedFavors;
  List<Favor> completedFfavors;
  List<Favor> refusedFavors;

  FavorsPageState();

  @override
  void initState() {
    super.initState();
    pendingAnswerFavors = List();
    acceptedFavors = List();
    completedFfavors = List();
    refusedFavors = List();
    loadFavors();
  }

  void loadFavors() {
    setState(() {
      pendingAnswerFavors.addAll(mockPendingFavors);
      acceptedFavors.addAll(mockDoingFavors);
      completedFfavors.addAll(mockCompletedFavors);
      refusedFavors.addAll(mockRefusedFavors);
    });
  }

  static FavorsPageState of(BuildContext context) {
    return context.findAncestorStateOfType<FavorsPageState>();
  }

  void refuseTodo(Favor favor) {
    setState(() {
      pendingAnswerFavors.remove(favor);
      refusedFavors.add(favor.copyWith(accepted: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your favors"),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              _buildCategoryTab("Requests"),
              _buildCategoryTab("Doing"),
              _buildCategoryTab("Completed"),
              _buildCategoryTab("Refused"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _bulidFavorsList("Pending Requests", pendingAnswerFavors),
            _bulidFavorsList("Doing", acceptedFavors),
            _bulidFavorsList("Completed", completedFfavors),
            _bulidFavorsList("Refused", refusedFavors),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RequestFavorPage(
                      friends: mockFriends,
                    )));
          },
          tooltip: 'Ask a favor',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = (screenWidth > 500) ? 32.0 : 16.0;
    titleStyle = titleStyle.copyWith(
      fontSize: fontSize,
    );
    return Tab(
      child: Text(
        title,
        style: titleStyle,
      ),
    );
  }

  Widget _bulidFavorsList(String title, List<Favor> favors) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardsPerRow = max(screenWidth ~/ kFavorMaxWidth, 1);

    print("Favors size: ${favors.length}");
    print("Screen width: ${screenWidth}");
    if (screenWidth > 400) {
      print("Card per row ${cardsPerRow}");
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2.8, crossAxisCount: cardsPerRow),
        itemBuilder: (BuildContext context, int index) {
          final favor = favors[index];
          return FavorCardItem(
            favor: favor,
          );
        },
        scrollDirection: Axis.vertical,
        itemCount: favors.length,
        physics: BouncingScrollPhysics(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text(title),
          padding: EdgeInsets.only(top: 16.0),
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: favors.length,
            itemBuilder: (BuildContext context, int index) {
              final favor = favors[index];
              return FavorCardItem(
                favor: favor,
              );
            },
          ),
        ),
      ],
    );
  }

  void refuseToDo(Favor favor) {
    setState(() {
      pendingAnswerFavors.remove(favor);

      refusedFavors.add(favor.copyWith(accepted: false));
    });
  }

  void acceptToDo(Favor favor) {
    setState(() {
      pendingAnswerFavors.remove(favor);

      acceptedFavors.add(favor.copyWith(accepted: true));
    });
  }

  void giveUp(Favor favor) {
    setState(() {
      acceptedFavors.remove(favor);

      refusedFavors.add(favor.copyWith(
        accepted: false,
      ));
    });
  }

  void complete(Favor favor) {
    setState(() {
      acceptedFavors.remove(favor);

      completedFfavors.add(favor.copyWith(
        completed: DateTime.now(),
      ));
    });
  }
}

class FavorCardItem extends StatelessWidget {
  final Favor favor;

  const FavorCardItem({Key key, this.favor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.title;
    return Card(
      key: ValueKey(favor.uuid),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        child: Column(
          children: <Widget>[
            _itemHeader(context, favor),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  favor.description,
                  style: bodyStyle,
                ),
              ),
            ),
            _itemFooter(context, favor)
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _itemFooter(BuildContext context, Favor favor) {
    if (favor.isCompleted) {
      final format = DateFormat();
      return Container(
//        padding: EdgeInsets.only(top: 8.0),
        alignment: Alignment.centerRight,
        child: Chip(
          label: Text(
            "Completed at: ${format.format(favor.completed)}",
            style: Theme.of(context).textTheme.body2,
          ),
        ),
      );
    }
    if (favor.isRequested) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text("Refuse"),
            onPressed: () {
              FavorsPageState.of(context).refuseToDo(favor);
            },
          ),
          FlatButton(
            child: Text("Do"),
            onPressed: () {
              FavorsPageState.of(context).acceptToDo(favor);
            },
          )
        ],
      );
    }
    if (favor.isDoing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text("give up"),
            onPressed: () {
              FavorsPageState.of(context).giveUp(favor);
            },
          ),
          FlatButton(
            child: Text("complete"),
            onPressed: () {
              FavorsPageState.of(context).complete(favor);
            },
          )
        ],
      );
    }

    return Container();
  }

  Widget _itemHeader(BuildContext context, Favor favor) {
    final headerStyle = Theme.of(context).textTheme.subhead;

    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(
            favor.friend.photoURL,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "${favor.friend.name} asked you to... ",
              style: headerStyle,
            ),
          ),
        )
      ],
    );
  }
}
