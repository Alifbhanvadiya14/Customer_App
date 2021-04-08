import 'package:Service/src/ui/cartpg.dart';

import '../ui/enquire.dart';
import 'package:flutter/material.dart';
import '../ui/viewallprods.dart';
import 'ProdList.dart';

class StorePg extends StatefulWidget {
  final String title;
  final String img;
  final String loc;
  final String tag;
  StorePg({this.title, this.img, this.loc, this.tag});
  @override
  _StorePgState createState() => _StorePgState();
}

class _StorePgState extends State<StorePg> {
  @override
  Widget build(BuildContext context) {
    print("Grocery Title : " + widget.title);
    print(widget.tag);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPg()));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Icon(
                Icons.shopping_cart,
                size: 20,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 11,
              color: Color(0xff2874F0),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.search),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Search for Products',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3.0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: NetworkImage(widget.img)))),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.title.toUpperCase(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    Text(widget.loc),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      MaterialButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyCustomForm(
                                      name: widget.title, id: widget.tag)));
                        },
                        child: Text("Enquire Now"),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Products",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllProd(
                            id: widget.tag,
                          ),
                        ),
                      );
                    },
                    child: Text("View All"),
                  )
                ],
              ),
            ),
            ProdList(
              tag: widget.tag,
              name: widget.title,
            )
          ],
        ),
      ),
    );
  }
}
