import 'package:flutter/material.dart';

class Fifthlist extends StatefulWidget {
  @override
  _FifthlistState createState() => _FifthlistState();
}

class _FifthlistState extends State<Fifthlist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.45,
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8, top: 8),
              child: Text(
                'Featured Store',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: Text(
                'Sponsored',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Image.network(
              "https://st4.depositphotos.com/25867432/29455/v/1600/depositphotos_294556364-stock-illustration-web-page-design-template-grocery.jpg",
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
    );
  }
}
