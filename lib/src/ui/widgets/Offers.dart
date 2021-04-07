import 'package:Service/src/ui/dryclean.dart';
import 'package:Service/src/ui/manpower.dart';

import '../cafe.dart';

import 'package:flutter/material.dart';
import '../hotel.dart';

class Thirdlist extends StatefulWidget {
  @override
  _ThirdlistState createState() => _ThirdlistState();
}

class _ThirdlistState extends State<Thirdlist> {
  var name = [
    "assets/hotel.png",
    "assets/dryclean.jpg",
    "assets/cafe.png",
    "assets/manpower.png",
  ];

  buildItem(BuildContext context, int index, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (title == "Hotel Booking") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HotelList()));
              } else if (title == "Dry Cleaning") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DryClean()));
              } else if (title == "Cafe Booking") {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cafe()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ManPower()));
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 4,
              child: Image.asset(
                name[index],
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 4,
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3.5,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildItem(context, 0, "Hotel Booking"),
          buildItem(context, 1, "Dry Cleaning"),
          buildItem(context, 2, "Cafe Booking"),
          buildItem(context, 3, "Man Power")
        ],
      ),
    );
  }
}
