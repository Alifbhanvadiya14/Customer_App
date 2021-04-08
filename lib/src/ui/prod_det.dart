import 'package:shared_preferences/shared_preferences.dart';

import '../ui/ProdList.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdDet extends StatefulWidget {
  final String title;
  final String url;
  final int sp;
  final int cp;
  final String tag, name;
  final String quan;
  ProdDet(
      {this.title, this.url, this.quan, this.cp, this.sp, this.tag, this.name});
  @override
  _ProdDetState createState() => _ProdDetState();
}

class _ProdDetState extends State<ProdDet> {
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
    super.initState();
    getPreFab();
  }

  int orderitemquan = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(widget.url))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.quan,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                widget.cp == widget.sp
                    ? Text(
                        "₹ " + widget.cp.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      )
                    : Row(
                        children: [
                          Text(
                            "₹ " + widget.cp.toString() + " ",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.lineThrough),
                          ),
                          Text(
                            "₹ " + widget.sp.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )
                        ],
                      ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        orderitemquan++;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "+",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    orderitemquan.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (orderitemquan == 1 || orderitemquan < 1) {
                          print("mai charas hu");
                        } else {
                          orderitemquan--;
                        }
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "-",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20, right: 40),
            child: MaterialButton(
              onPressed: () {
                print("ss");
                FirebaseFirestore.instance.collection('cart').add({
                  "prod_name": widget.title,
                  "prod_max_price": widget.cp,
                  "prod_price": widget.sp,
                  "prod_quan": orderitemquan,
                  "prod_img": widget.url,
                  "user_id": userId,
                  "username": name,
                  "vendor_tag": widget.tag,
                  "vendor_name": widget.name,
                  "timestamp": DateTime.now(),
                  "prod_size": widget.quan
                }).then((value) => showInSnackBar("Item Added"));
              },
              color: Colors.orange,
              textColor: Colors.white,
              child: Text("Add to Cart"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              "Product Description",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20, right: 16),
            child: Text(
              "To take your coffee experiences to the next level, NESCAFÉ, the world’s favourite instant coffee brand, brings forth a rich and aromatic coffee in the form of NESCAFÉ Classic. ",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text("View All")
              ],
            ),
          ),
          ProdList()
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
