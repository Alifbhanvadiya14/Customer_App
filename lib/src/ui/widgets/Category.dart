import '../vendor.dart';
import 'package:flutter/material.dart';

class Firstlist extends StatefulWidget {
  @override
  _FirstlistState createState() => _FirstlistState();
}

class _FirstlistState extends State<Firstlist> {
  var name = [
    "assets/grocery.png",
    "assets/giftss.jpg",
    "assets/foood.jpg",
    "assets/fruitsveg.jpg",
  ];

  buildItem(BuildContext context, int index, String title, String typeTag) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VendorList(
                    title: title,
                    type: typeTag,
                  ),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 7,
              child: Image.asset(
                name[index],
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 4,
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      height: MediaQuery.of(context).size.height / 5,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildItem(context, 0, "Grocery", "grocery"),
          buildItem(context, 1, "Gifts and Stationary", "gifts_stationary"),
          buildItem(context, 2, "Foods and Beverages", "food_beverages"),
          buildItem(context, 3, "Fruits and Vegetables", "fruits_vegetable"),
          Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
