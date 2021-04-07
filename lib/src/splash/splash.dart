import 'dart:async';

import 'package:Service/provider/location_provider.dart';
import 'package:Service/src/ui/boarding/enterphone.dart';
import 'package:Service/src/ui/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool islogged;
  getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString("phone"));
    setState(() {
      islogged = prefs.getBool("isLogged");
    });
  }

  

  void initState() {
    super.initState();
  
    getuserdata();
        Provider.of<LocationProvider>(context,listen:false).initializtion();

    Timer(Duration(seconds: 2), () {
      print(islogged);
      if (islogged == true) {
        print("User is already logged in");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        print("User is not logged in");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => EnterPhonepage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 200,
                margin: EdgeInsets.symmetric(
                    // horizontal: MediaQuery.of(context).size.width * 0.2,
                    ),
                child:
                    Center(child: Image(image: AssetImage("assets/logo.png")))),
            Container(
              width: 220,
              // margin: EdgeInsets.symmetric(),
              child: LinearProgressIndicator(
                backgroundColor: Colors.blueAccent,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
