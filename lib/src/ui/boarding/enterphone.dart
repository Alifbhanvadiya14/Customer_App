import 'dart:math';

import 'package:Service/src/Constant/colors.dart';
import 'package:Service/src/ui/boarding/enter_otp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterPhonepage extends StatefulWidget {
  String phone;
  EnterPhonepage({this.phone});

  @override
  _EnterPhonepageState createState() => _EnterPhonepageState();
}

class _EnterPhonepageState extends State<EnterPhonepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String code = "2342";
  TextEditingController _phoneController = TextEditingController();

  void randomOtp() {
    Random random = Random();
    setState(() {
      code = random.nextInt(10000).toString();
    });
    print("code is $code");
    widget.phone = _phoneController.text;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomOtp();
    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height *0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, top: 60),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Let Us Know You \nBetter",
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
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      child: Text(
                        "Enter Your Phone",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          fontSize: 23,
                          color: Color.fromRGBO(70, 67, 211, 1),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                      height: 50,
                      width: 343,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        decoration: InputDecoration(
                            labelText: "Enter phone",
                            prefixIcon: Icon(
                              // Icons.phone,
                              Icons.contact_phone,
                              size: 18,
                            ),
                            // hintText: "placeholder",
                            hintStyle: GoogleFonts.montserrat(fontSize: 19),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(70, 67, 211, 1),
                                  width: 2,
                                )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            )),
                        minLines: 1,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 21),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 55,
                  width: 343,
                  child: FlatButton(
                    onPressed: () {
                      if (_phoneController.text.length == 10) {
                        // ApiService.sendOtp(_phoneController.text, code);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterOtppage(
                                      code: code,
                                      phonenumber: _phoneController.text,
                                    )));
                      } else {
                        _showSnackMessage("Phone number must be of 10 digits");

                        // snack bar
                        //  Phone number must be of 10 digits
                      }
                    },
                    child: Text(
                      "Get Started Now",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 16),
                    ),
                    color: ColorPalatte.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
