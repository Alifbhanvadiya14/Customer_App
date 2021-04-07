import 'dart:async';
import 'dart:io';

// import 'package:MUJ_GO/Services/push_notification.dart';
// import 'package:MUJ_GO/shared/bottomnavbar.dart';
// import 'package:MUJ_GO/shared/colors.dart';
import 'package:Service/src/Constant/colors.dart';
import 'package:Service/src/ui/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Createaccountscreen extends StatefulWidget {
  String phone;
  Createaccountscreen({this.phone});

  @override
  _CreateaccountscreenState createState() => _CreateaccountscreenState();
}

class _CreateaccountscreenState extends State<Createaccountscreen> {
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _deptname = TextEditingController();
  TextEditingController _registernumber = TextEditingController();

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

     final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    void _showSnackMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }





  setpref(String userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userid);
 
    prefs.setString("username", _fname.text + " " + _lname.text);
    prefs.setString("userfname", _fname.text);
    prefs.setString("phone", widget.phone);
    // prefs.setString("deptname", _deptname.text);
    prefs.setString("email", _email.text);
    // prefs.setString("registernum", _registernumber.text);
    prefs.setBool("isLogged", true)

 
        .then((value) => {print("Shared prefrences Set")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        body: SingleChildScrollView(
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(70, 67, 211, 1),
              // gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [Colors.deepOrangeAccent, Colors.orangeAccent]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          height: 175,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, top: 80),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Enter Your Details and \nLets Go ",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Container(
        //   padding: EdgeInsets.only(left: 20, top: 21, bottom: 10),
        //   width: MediaQuery.of(context).size.width,
        //   child: Text(
        //     "Create A Account ",
        //     style: GoogleFonts.montserrat(
        //       // color: Colors.white,
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 20,
        ),
    
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          nameinput("First name", _fname),
          nameinput("Last name", _lname),
        ]),
        linput("Enter your Email Address", "Email", Icons.email, _email),
        // linput("Enter your Departname Name", "Name", Icons.school_rounded,
            // _deptname),
        // linput("Enter your Registration Number", "Registration Number",
            // Icons.confirmation_number_outlined, _registernumber),
        Container(
          margin: EdgeInsets.only(
            top: 40,
          ),
          height: 55,
          width: 343,
          child: 

          RoundedLoadingButton(
                        loaderSize: 15,
                        controller: _btnController,
                        animateOnTap: true,
                        onPressed: () {
        
              var uuid = Uuid();
              var userid = uuid.v4();
              int time = 0;

              if (_fname.text.length > 3 &&
                  _lname.text.length > 3 &&
                  _email.text.length > 8) {

                    _btnController.start();
               
                      Timer(Duration(seconds: time), () {
                      FirebaseFirestore.instance
                            .collection("Users")
                            .doc(userid)
                            .set({
                          "userid": userid,
                     
                          "username": _fname.text + " " + _lname.text,
                          "userfname": _fname.text,
                          "phone": widget.phone,
                      
                          "email": _email.text,
                   
                        }).then((value) => {
                                  setpref(userid),
                                  // FirebaseNotifications().setUpFirebase(userid),
                                  _btnController.success(),
                                  Navigator.of(context).pop(),
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()))
                                });

                        // snack bar
                      });
                
              } else {
                print("Please Fill all the details");
                _showSnackMessage("Please Fill all valid details");
                _btnController.reset();
              }
            },
            child: Text(
              "Get Started Now",
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
            ),
            color: ColorPalatte.primary,
          ),
        ),
      ]),
    ));
  }

  Widget linput(String placeholder, String label, IconData icon,
      TextEditingController _controller) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            height: 50,
            width: 343,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: placeholder,
                  prefixIcon: Icon(
                    // Icons.phone,
                    icon,
                    size: 18,
                  ),
                  // hintText: "placeholder",
                  hintStyle: GoogleFonts.montserrat(fontSize: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              minLines: 1,
              maxLines: 1,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget nameinput(name, TextEditingController _controller) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: Text(
              name,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            height: 50,
            width: 165,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  // labelText: "Email",
                  // prefixIcon: Icon(icon),
                  // hintText: "placeholder",
                  hintStyle: GoogleFonts.montserrat(fontSize: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              minLines: 1,
              maxLines: 1,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
