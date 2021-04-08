import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCustomForm extends StatefulWidget {
  final String name, id;

  const MyCustomForm({Key key, this.name, this.id}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    ScaffoldMessengerState()
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  final username = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final enquiry = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Enquiry Form",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: new Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextField(
              controller: username,
              decoration: new InputDecoration(
                hintText: "Name",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: new TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: new InputDecoration(
                hintText: "Phone",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                hintText: "Email",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.comment),
            title: new TextField(
              controller: enquiry,
              decoration: new InputDecoration(
                hintText: "Enquiry",
              ),
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: RaisedButton(
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                FirebaseFirestore.instance.collection("enquiries").add({
                  "userId": userId,
                  "username": username.text,
                  "vendor_id": widget.id,
                  "vendor_name": widget.name,
                  "useremail": emailController.text,
                  "userphone": phoneController.text,
                  "enquiry": enquiry.text,
                }).whenComplete(() => {
                      //showInSnackBar("Enquiry Submitted")
                      Navigator.pop(context),
                    });
              },
              child: Text("Submit"),
            ),
          )
        ],
      ),
    );
  }
}
