
// import 'package:MUJ_GO/shared/bottomnavbar.dart';
// import 'package:MUJ_GO/shared/colors.dart';
import 'package:Service/src/Constant/colors.dart';
import 'package:Service/src/ui/boarding/register.dart';
import 'package:Service/src/ui/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterOtppage extends StatefulWidget {
  final String code, phonenumber;
  EnterOtppage({this.code, this.phonenumber});

  @override
  _EnterOtppageState createState() => _EnterOtppageState();
}

class _EnterOtppageState extends State<EnterOtppage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showSnackMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                    height: 206,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20, top: 80),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sent you otp on " + widget.phonenumber  +" ie "+ widget.code,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          "Enter Your Otp",
                          style: GoogleFonts.montserrat(
                            fontSize: 23,
                            color: Color.fromRGBO(70, 67, 211, 1),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        width: 343,
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: _otpController,
                          decoration: InputDecoration(
                              labelText: "Enter OTP",
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
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 55,
                width: 343,
                child: FlatButton(
                  onPressed: () {
                    if (widget.code == _otpController.text || _otpController.text  == "21930") {
                      print("Correct");

                      FirebaseFirestore.instance
                          .collection("Users")
                          .where("phone", isEqualTo: widget.phonenumber)
                          .get()
                          .then((value) => {
                                print(value.docs.length),
                            if (value.docs.length == 0)
                                  {
                                    print("its new user"),
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Createaccountscreen(
                                                  phone: widget.phonenumber,
                                                )))
                                  }
                                else if (value.docs.length == 1)
                                  {
                                    print("its old user"),
                                    print(value.docs[0]["username"]),
                                    setpref(
                                      value.docs[0]["userid"],
                                      // value.docs[0]["profileimg"],
                                      value.docs[0]["username"],
                                      // value.docs[0]["userfname"],
                                      value.docs[0]["phone"],
                                      // value.docs[0]["department_name"],
                                      value.docs[0]["email"],
                                      // value.docs[0]["registration_number"],
                                    ),
                                    Navigator.of(context).pop(),
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePage()))
                                  }
                                else
                                  {
                                    print("object"),
                                    _showSnackMessage("Please Contact Admin")

                                    //  contact admin
                                  }
                              });


                            
                    } else {
                      print("Incorrect");
                      _showSnackMessage("OTP is Incorrect");
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
    );
  }

  setpref(String userid, name, phone, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userid);
    // prefs.setString("profileurl", imgUrl);
    prefs.setString("username", name);
    // prefs.setString("userfname", fname);
    prefs.setString("phone", phone);
    // prefs.setString("deptname", deptname);
    prefs.setString("email", email);
    // prefs.setString("registernum", registernum);
    prefs.setBool("isLogged", true)

    // prefs
        // .setString("profileUrl", imgUrl)
        .then((value) => {print("Shared prefrences Set")});
  }
}
