import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './ui/home.dart';
void main() {
  var title = "voting_demo";
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((pref) {
    runApp(new MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: new Home(title: title,preferences: pref,),

    ));
  });
}
