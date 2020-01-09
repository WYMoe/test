import 'package:flutter/material.dart';
import 'listViewPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
class Home extends StatefulWidget {
  final SharedPreferences preferences;
  final String title;

  Home({Key key, this.title ,this.preferences}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
    


  List<String> category = [
    "Fresher King",
    "Fresher Queen",
    "The Whole King",
    "The Whole Queen"
  ];
  String login;
  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences=widget.preferences;

    return new Scaffold(
       // backgroundColor: Colors.teal[300],
        appBar: new AppBar(
          title: new Text(
            "Fresher Welcome", style: new TextStyle(color: Colors.white,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w800),),
          centerTitle: true,
          backgroundColor: Colors.teal[300],
        ), //appbar
        body: new Container(
//          decoration: BoxDecoration(
//              image: DecorationImage(
//                image: AssetImage('assets/images/bg.jpg'),
//                fit: BoxFit.cover,)),,

          child: new Container(
            margin: const EdgeInsets.only(top: 70.0),

            child: GridView(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              children: category.map((title) {
                return InkWell(
                  onTap: () {

                    var router = new MaterialPageRoute(
                        builder: (BuildContext context){
                          return new ListViewPage(title: title,sharedPreferences: preferences,);
                        });
                    Navigator.of(context).push(router);

                  },

                  child: Card(
                    elevation: 5.5,
                    //color: Colors.blueGrey[50],
                    margin: EdgeInsets.all(20.0),
                    child: getCardBytitle(title,),
                    shape: RoundedRectangleBorder(


                      borderRadius: BorderRadius.circular(16.0)
                    ),

                  ),

                );
              }).toList(),
            ),

          ),

        ),
    );
  }

  Column getCardBytitle(String title) {
    String img = '';
    if (title == "Fresher King") {
      img = 'assets/images/FresherKing.png';
    } else if (title == "Fresher Queen") {
      img = 'assets/images/FresherQueen.png';
    } else if (title == "The Whole King") {
      img = 'assets/images/TheWholeKing.png';
    } else {
      img = 'assets/images/TheWholeQueen.png';
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Center (
          child: new Container(
            padding: const EdgeInsets.only(bottom: 10.5),
            child: new Stack(
              children: <Widget>[
                new Image.asset(
                  img,
                  width: 80.0,
                  height: 80.0,
                ),
              ],
            ),
          ),
        ),
        new Text(title,
          style: new TextStyle(
            fontSize: 15.0,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,),
          textAlign: TextAlign.center,
        )
      ],
    );
  }


}