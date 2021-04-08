import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';

import 'orderconfirmscreen.dart';

class BookManpower extends StatefulWidget {
  final String id;
  final String name;
  final DocumentSnapshot packageSnapshot;

  const BookManpower({Key key, this.id, this.name, this.packageSnapshot})
      : super(key: key);

  @override
  _BookManpowerState createState() => _BookManpowerState();
}

class _BookManpowerState extends State<BookManpower> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime _selectedDate;

  String type = "x";
  int cost = 0;
  int differenceInDays = 0;
  TextEditingController _textEditingController = TextEditingController();

  TextEditingController _textEditingControllerCheckout =
      TextEditingController();

  // TextEditingController adults = TextEditingController();
  // TextEditingController child = TextEditingController();
  TextEditingController phn = TextEditingController();
  TextEditingController totalPrice = TextEditingController();
  TextEditingController username = TextEditingController();
  int totprice = 0;
  bool isselected = false;
  int selctedprice = 0;
  // List<SmartSelectOption<String>> list;
  //
  String name, email, phone, userId;

  getPreFab() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");

      name = prefs.getString("username");
      email = prefs.getString("email");

      phone = prefs.getString("phone");
    });
  }

  @override
  void initState() {
    getPreFab();
    super.initState();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    totalPrice.text = widget.packageSnapshot.data()["package_price"].toString();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Book Now",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: "Booking Date"),
              focusNode: AlwaysDisabledFocusNode(),
              controller: _textEditingController,
              onTap: () {
                _selectDate(
                    context, _textEditingController, "cin", _selectedDate);
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     keyboardType: TextInputType.number,
          //     decoration: InputDecoration(labelText: "Number of Persons"),
          //     controller: adults,
          //   ),
          // ),
          // SmartSelect<String>.single(
          //     title: "Choose Slot",
          //     modalType: SmartSelectModalType.bottomSheet,
          //     options: list,
          //     value: "This is value",
          //     onChange: (selected) {
          //       type = selected;
          //       print(type);
          //       print(selected);
          //     }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: username,
              decoration: InputDecoration(labelText: "Customer Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              readOnly: true,
              controller: totalPrice,
              decoration: InputDecoration(labelText: "Total Amount"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              child: Text("Confirm Booking"),
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                if (_textEditingController.text != "" && username.text != "") {
                  print("here");

                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        //color: Colors.amber,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text(
                                "Confirm Booking",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // Text(
                              //   "For " + adults.text + " people",
                              //   style: TextStyle(fontWeight: FontWeight.bold),
                              // ),
                              SizedBox(
                                height: 5,
                              ),
                              RaisedButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    var rand = Random();
                                    int id = rand.nextInt(100000);
                                    FirebaseFirestore.instance
                                        .collection('order-booking')
                                        .add({
                                      "booking_id": id,
                                      "customer_phone": "7457030549",

                                      "user_id": userId,
                                      "guest_name": username.text,
                                      "manpower_id": widget.id,
                                      "manpower_name": widget.name,
                                      "package_name": widget.packageSnapshot
                                          .data()["package_name"],
                                      "package_id": widget.packageSnapshot
                                          .data()["package_id"],
                                      // "no_of_person": adults.text,
                                      // "booking_slot": type,
                                      "booking_date":
                                          _textEditingController.text,
                                      "total_amount":
                                          int.parse(totalPrice.text),
                                    }).then((value) => {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          OrderConfirm(
                                                            orderId: id,
                                                            msg:
                                                                "Your Service is Booked",
                                                          )))
                                            });
                                  })
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (_textEditingController.text == "") {
                  showInSnackBar("Please enter  date");
                } else if (username.text == "") {
                  showInSnackBar("Please enter your name");
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _selectDate(BuildContext context, TextEditingController text, String iswhat,
      DateTime type) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: type != null ? type : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.black,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.black,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      type = newSelectedDate;

      text
        ..text = DateFormat.yMMMd().format(type)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textEditingController.text.length,
            affinity: TextAffinity.upstream));
      if (iswhat == "cin") {
        _selectedDate = type;
      } // else {
      //   // _checkoutdate = type;
      // }
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
