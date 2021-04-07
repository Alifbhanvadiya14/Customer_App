import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_select/smart_select.dart';

class BookCafe extends StatefulWidget {
  final String id;
  final String name;

  BookCafe({this.id, this.name});

  @override
  _BookCafeState createState() => _BookCafeState();
}

class _BookCafeState extends State<BookCafe> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime _selectedDate;
  DateTime _checkoutdate;
  
  String type = "x";
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
  
    list = List<SmartSelectOption<String>>();
    // TODO: implement initState
    for (int i = 4; i < 10; i = i + 2) {
      list.add(
        SmartSelectOption<String>(
          title: i.toString() + ":30", value: i.toString() + ":30"));
    }
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
              decoration: InputDecoration(hintText: "Booking Date"),
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Number of Persons"),
              controller: adults,
            ),
          ),
          SmartSelect<String>.single(
              title: "Choose Slot",
              modalType: SmartSelectModalType.bottomSheet,
              options: list,

              value: "This is value",
              onChange: (selected) {
                type = selected;
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
                    type != "x" &&
                    adults.text != "" &&
                    username.text != "") {
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
                              Text(
                                "For " + adults.text + " people",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              RaisedButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('cafe-bookings')
                                        .add({
                                      "booking_id": "45321",
                                      "customer_phone": "7457030549",

                                      "guest_id": "Bhoomika12345",
                                      "guest_name": username.text,
                                      "cafe_id": widget.id,
                                      "cafe_name": widget.name,

                                      "no_of_person": adults.text,
                                      "booking_slot": type,
                                      "booking_date":
                                          _textEditingController.text,
                                      //"total_amount": price,
                                    }).then((value) => {
                                              Navigator.pop(context),
                                              showInSnackBar(
                                                  "Booking confirmed")
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
                } else if (adults.text == "") {
                  showInSnackBar("Please enter number of persons");
                } else if (username.text == "") {
                  showInSnackBar("Please enter your name");
                } else if (type == "x") {
                  showInSnackBar("Please choose slot");
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
