import 'package:flutter/material.dart';

import 'homePage.dart';

class OrderConfirm extends StatelessWidget {
  final int orderId;
  final String msg;

  const OrderConfirm({Key key, this.orderId, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/gifs/animation_640_kn8prs79.gif"),
            SizedBox(height: 20),
            Text(
              msg,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Order Id : ${orderId.toString()}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            MaterialButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                child: Text(
                  "Return to Home Page",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
