import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDryClean extends StatefulWidget {
  final String shopid;
  final String serviceid;
  final int cost;
  final String clothes;
  final String shopname;
  final String servicename;

  BookDryClean(
      {this.shopid,
      this.shopname,
      this.serviceid,
      this.clothes,
      this.cost,
      this.servicename});

  @override
  _BookDryCleanState createState() => _BookDryCleanState();
}

class _BookDryCleanState extends State<BookDryClean> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime _selectedDate;

   String name,email,phone,userId;

getPreFab() async{
  
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        
        userId  = prefs.getString("userId");

        name  = prefs.getString("username");
                email  = prefs.getString("email");

        phone  = prefs.getString("phone");


      });

}


  double totalcost = 0.0;
  String type = "x";
  int cost = 0;
  int differenceInDays = 0;
  Razorpay razorpay;
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

  @override
  void initState() {
    // razorpay = new Razorpay();
    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, success);
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, ext);
    // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, err);
    getPreFab();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    razorpay.clear();
    super.dispose();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_BaWyx58BRYldrJ",
      "amount": totalcost * 100,
      "name": "Bakhera",
      "description": "Payment for the drycleaning",
      'order_id': 'order_EMBFqjDHEEn80l',
       'timeout': 60, 
      "prefill": {"contact": "2323232323", "email": "shdjsdh@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

//     var aa = {
//   'key': '<YOUR_KEY_ID>',
//   'amount': 50000, //in the smallest currency sub-unit.
//   'name': 'Acme Corp.',
//  // Generate order_id using Orders API
//   'description': 'Fine T-Shirt',
//  // in seconds
//   'prefill': {
//     'contact': '9123456789',
//     'email': 'gaurav.kumar@example.com'
//   }
// };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void success() {

     var rand = Random();
    int id = rand.nextInt(100000);
    FirebaseFirestore.instance.collection('order-booking').add({
      "type": "drycleaning",
      "booking_id": id,
      "user_phone": phone,
"timeStamp": DateTime.now(),
      "user_id": userId,
      "user_name": username.text,
      "dryclean_shop_id": widget.shopid,
      "service_id": widget.serviceid,
      "total_cost": totalcost,
      "no_of_clothes": adults.text,
      "dryclean_shop_name": widget.shopname,
      "service_name": widget.servicename,

      "service_date": _textEditingController.text,
      //"total_amount": price,
    }).then((value) =>
        {Navigator.pop(context), showInSnackBar("Booking confirmed")});
  }

  void err(PaymentFailureResponse response) {
    showInSnackBar("Payment Fail");
  }

  void ext(ExternalWalletResponse response) {
    showInSnackBar("Ext");
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
              decoration: InputDecoration(labelText: "Number of Clothes"),
              controller: adults,
            ),
          ),
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
              child: Text("Confirm"),
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                if (_textEditingController.text != "" &&
                    adults.text != "" &&
                    username.text != "") {
                
                  double costonecloth = widget.cost / int.parse(widget.clothes);
                  totalcost = int.parse(adults.text) * costonecloth;
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
                                "Confirm Service",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "For " + adults.text + " clothes",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Total Cost-> " + totalcost.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              RaisedButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    // openCheckout();
                                    success();

                                  })
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (_textEditingController.text == "") {
                  showInSnackBar("Please enter date");
                } else if (adults.text == "") {
                  showInSnackBar("Please enter number of clothes");
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
      }
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
