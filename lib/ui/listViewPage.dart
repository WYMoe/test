import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListViewPage extends StatefulWidget {
  String title;
  final SharedPreferences sharedPreferences;

  ListViewPage({Key key, this.title, this.sharedPreferences}) : super(key: key);

  @override
  _ListViewPageState createState() => new _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  String _text_for_btn = "";

  Stream fresherKing = Firestore.instance
      .collection("contestants")
      .document("king")
      .collection("fresher_king")
      .snapshots();
  Stream theWholeKing = Firestore.instance
      .collection("contestants")
      .document("king")
      .collection("the_whole_king")
      .snapshots();
  Stream fresherQueen = Firestore.instance
      .collection("contestants")
      .document("queen")
      .collection("fresher_queen")
      .snapshots();

  Stream theWholeQueen = Firestore.instance
      .collection("contestants")
      .document("queen")
      .collection("the_whole_queen")
      .snapshots();

  var docRef = Firestore.instance.collection("user");


  Stream getData() {
    if (widget.title == "Fresher King") {
      return fresherKing;
    } else if (widget.title == "Fresher Queen") {
      return fresherQueen;
    } else if (widget.title == "The Whole King") {
      return theWholeKing;
    } else if (widget.title == "The Whole Queen") {
      return theWholeQueen;
    }
  }
//      clear()async{
//  QuerySnapshot userIdSnapshot = await Firestore.instance.collection("users")
//      .getDocuments();
//  var userIdList = userIdSnapshot.documents;
//
//  for(int i = 0; i< 650 ;i++){
//    var id = userIdList[i].documentID;
//    Firestore.instance.collection('users').document(id).updateData({'Fresher King':false,'Fresher Queen':false,'The Whole Queen':false,'The Whole King':false});
//
//  }
//}

  @override
  Widget build(BuildContext context) {
    //Firestore.instance.collection('votes').document('-LxbMsQholcuj01Z6r_0').updateData({widget.title:true,});

    if (widget.sharedPreferences.get('login') == null) {
      setState(() {
        _text_for_btn = "Scan and Vote";
      });
    } else {
      setState(() {
        _text_for_btn = "Vote";
      });
    }
    return new Scaffold(
        body: StreamBuilder(
            stream: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return new Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.teal[400],
                    strokeWidth: 5,
                  ),
                );
              } else {
                return CustomScrollView(slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.teal[400],
                    expandedHeight: 280,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        "${widget.title}",
                        style: new TextStyle(
                            color: Colors.white,
                            fontFamily: 'Raleway',
                            fontSize: 21.5,
                            fontWeight: FontWeight.bold),
                      ),
                      background: Image.asset(
                        'assets/images/main.png',
                        fit: BoxFit.contain,
                        width: 10.5,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      DocumentSnapshot post = snapshot.data.documents[index];
                      return Container(
                        padding: const EdgeInsets.all(10.5),
                        child: Card(
                          elevation: 2.5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.2)),
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 280.0,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Image.network(
                                        '${post['image']}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20.0,
                                      left: 16.0,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${post['no']}\n${post['name']}\n${post['year']}\n${post['major']}',
                                          style: TextStyle(
                                              fontSize: 16.5,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w900,
                                              color: Colors.cyan[900]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    width: 350,
                                    child: FlatButton(
                                        child: new Text(
                                          _text_for_btn,
                                          style: new TextStyle(
                                              color: Colors.blueGrey,
                                              fontFamily: "Raleway",
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        onPressed: () async {
                                          var validID = "default";
                                          QuerySnapshot userIdSnapshot =
                                              await Firestore.instance
                                                  .collection("users")
                                                  .getDocuments();
                                          var userIdList =
                                              userIdSnapshot.documents;

                                          if (widget.sharedPreferences
                                                  .get('login') ==
                                              null) {
                                            String cameraScanResult =
                                                await scanner.scan();

                                            for (int i = 0;
                                                i < userIdList.length;
                                                i++) {
                                              if ("$cameraScanResult" ==
                                                  userIdList[i].documentID) {
                                                widget.sharedPreferences
                                                    .setString('login',
                                                        cameraScanResult);
                                                validID =
                                                    userIdList[i].documentID;
                                                setState(() {
                                                  _text_for_btn = "Vote";
                                                });

                                                Firestore.instance
                                                    .collection('users')
                                                    .document(validID)
                                                    .get()
                                                    .then(
                                                        (DocumentSnapshot ds) {
                                                  if (ds.data[widget.title] ==
                                                      false) {
                                                    Firestore.instance
                                                        .runTransaction(
                                                            (transaction) async {
                                                      Firestore.instance
                                                          .collection("votes")
                                                          .document(
                                                              widget.title)
                                                          .collection(
                                                              post.documentID)
                                                          .document(validID)
                                                          .setData({
                                                        "voterID": "$validID"
                                                      });
                                                      Firestore.instance
                                                          .collection('users')
                                                          .document(validID)
                                                          .updateData({
                                                        widget.title: true
                                                      });
                                                      print(ds
                                                          .data[widget.title]);
                                                    });
                                                  }
                                                });
                                                break;
                                              }
                                            }
                                          } else if (widget.sharedPreferences
                                                  .get('login') !=
                                              null) {
                                            validID = widget.sharedPreferences
                                                .get('login');

                                            Firestore.instance
                                                .collection('users')
                                                .document(validID)
                                                .get()
                                                .then((DocumentSnapshot ds) {
                                              print(ds.data[widget.title]);
                                              if (ds.data[widget.title] ==
                                                  false) {
                                                Firestore.instance
                                                    .runTransaction(
                                                        (transaction) async {
                                                  Firestore.instance
                                                      .collection("votes")
                                                      .document(widget.title)
                                                      .collection(
                                                          post.documentID)
                                                      .document(validID)
                                                      .setData({
                                                    "voterID": "$validID"
                                                  });
                                                  Firestore.instance
                                                      .collection('users')
                                                      .document(validID)
                                                      .updateData(
                                                          {widget.title: true});
                                                  print(ds.data[widget.title]);
                                                });
                                              }
                                            });
                                          }

                                          print(validID);
                                          DocumentSnapshot check =
                                              await Firestore.instance
                                                  .collection('users')
                                                  .document(validID)
                                                  .get();
                                          bool valid;
                                          if (validID == "default") {
                                            valid = false;
                                          } else {
                                            valid = true;
                                          }

                                          if (valid == true &&
                                              check[widget.title]) {
                                            return Alert(
                                                context: context,
                                                title:
                                                    "You have already voted for ${widget.title}!",
                                                buttons: [
                                                  DialogButton(
                                                      child: Text("OK",
                                                          style: new TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Raleway",
                                                              fontSize: 15.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800)),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      })
                                                ]).show();
                                          } else if (valid == true &&
                                              check[widget.title] == false) {
                                            return Alert(
                                                context: context,
                                                title:
                                                    "You have voted to ${post['name']}",
                                                buttons: [
                                                  DialogButton(
                                                      child: Text("OK",
                                                          style: new TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Raleway",
                                                              fontSize: 15.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800)),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      })
                                                ]).show();
                                          } else {
                                            return Alert(
                                                context: context,
                                                title: "Invalid!",
                                                buttons: [
                                                  DialogButton(
                                                      child: Text("Try Again",
                                                          style: new TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Raleway",
                                                              fontSize: 15.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800)),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      })
                                                ]).show();
                                          }
                                        }),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue[300],
                                      ),
                                      borderRadius: BorderRadius.circular(12.2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: snapshot.data.documents.length),
                  )
                ]);
              }
            }));
  }
}
