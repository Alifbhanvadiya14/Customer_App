import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';
import '../ui/hotel_det.dart';
import 'orderconfirmscreen.dart';

class BookHotel extends StatefulWidget {
  final String id;
  final String name;
  final List<HotelRoom> room;
  BookHotel({this.id, this.name, this.room});

  @override
  _BookHotelState createState() => _BookHotelState();
}

class _BookHotelState extends State<BookHotel> {
  String name, email, phone, userId;

  getPreFab() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");

      name = prefs.getString("username");
      email = prefs.getString("email");

      phone = prefs.getString("phone");

      username.text = name;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime _selectedDate;
  DateTime _checkoutdate;
  String type = "";
  int cost = 0;
  int differenceInDays = 0;

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingControllerCheckout =
      TextEditingController();
  TextEditingController adults = TextEditingController();
  TextEditingController child = TextEditingController();
  TextEditingController phn = TextEditingController();
  TextEditingController username = TextEditingController();
  int totprice = 0;
  bool isselected = false;
  int selctedprice = 0;

  List<SmartSelectOption<String>> list;
  @override
  void initState() {
    list = [];
    print(widget.room.length);
    // TODO: implement initState
    for (int i = 0; i < widget.room.length; i++) {
      print(widget.room[i].roomtype);
      list.add(
        SmartSelectOption<String>(
          title: widget.room[i].roomtype,
          value: widget.room[i].roomprice.toString(),
        ),
      );
    }
    getPreFab();
    super.initState();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: InputDecoration(hintText: "Check-In Date"),
              focusNode: AlwaysDisabledFocusNode(),
              controller: _textEditingController,
              onTap: () {
                _selectDate(
                    context, _textEditingController, "cin", _selectedDate);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: "CheckOut Date"),
              focusNode: AlwaysDisabledFocusNode(),
              controller: _textEditingControllerCheckout,
              onTap: () {
                _selectDate(context, _textEditingControllerCheckout, "cout",
                    _checkoutdate);

                // DateTime dateTimeCreatedAt =
                //     DateTime.parse(_textEditingController.text);
                // DateTime dateTimeNow =
                //     DateTime.parse(_textEditingControllerCheckout.text);
                // final differenceInDays =
                //     dateTimeNow.difference(dateTimeCreatedAt).inDays;
                // print(differenceInDays);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Number of Adults"),
              controller: adults,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: child,
              decoration: InputDecoration(labelText: 'Number of Children'),
            ),
          ),
          SmartSelect<String>.single(
              title: "Room Choice",
              modalType: SmartSelectModalType.bottomSheet,
              // options: list,
              options: list,
              value: "This is value",
              onChange: (selected) {
                setState(() {
                  cost = int.parse(selected);
                  type = selected;
                });
                print(type);
                print(selected);
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: username,
              decoration: InputDecoration(labelText: "Customer Name"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              child: Text("Confirm Booking"),
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                if (_textEditingController.text != "" &&
                    _textEditingControllerCheckout.text != "") {
                  differenceInDays = 4;
                  // _checkoutdate.difference(_selectedDate).inDays;
                }

                if (_textEditingController.text != "" &&
                    _textEditingControllerCheckout.text != "" &&
                    _textEditingControllerCheckout.text !=
                        _textEditingController.text &&
                    differenceInDays > 0 &&
                    username.text != "") {
                  print("here");

                  final int price = differenceInDays * cost;
                  print(price);
                  print(differenceInDays);

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
                              Text(
                                "For " + differenceInDays.toString() + " days",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Total-> " + price.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              MaterialButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    var rand = Random();
                                    int id = rand.nextInt(100000);

                                    FirebaseFirestore.instance
                                        .collection('order-booking')
                                        .add({
                                      "type": "hotel",
                                      "booking_id": id,
                                      "customer_phone": phone,
                                      "end_date":
                                          _textEditingControllerCheckout.text,
                                      "user_id": userId,
                                      "guest_name": username.text,
                                      "hotel_id": widget.id,
                                      "hotel_name": widget.name,
                                      "no_of_days": differenceInDays,
                                      "no_of_person": adults.text,
                                      "room_type": type,
                                      "start_date": _textEditingController.text,
                                      "total_amount": price,
                                      "timeStamp": DateTime.now(),
                                    }).then((value) => {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          OrderConfirm(
                                                            orderId: id,
                                                            msg:
                                                                "Your Room is Booked",
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
                  showInSnackBar("Please enter check-in date");
                } else if (_textEditingController.text ==
                    _textEditingControllerCheckout.text) {
                  showInSnackBar("Please select 2 different dates");
                } else if (_textEditingControllerCheckout.text == "") {
                  showInSnackBar("Please enter check-out date");
                } else if (adults.text == "") {
                  showInSnackBar("Please enter number of adults");
                } else if (username.text == "") {
                  showInSnackBar("Please enter your name");
                } else if (cost == 0) {
                  showInSnackBar("Please select room type");
                } else if (differenceInDays < 0) {
                  showInSnackBar(
                      "Check-out date should be after Check-In date");
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
      } else {
        _checkoutdate = type;
      }
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
