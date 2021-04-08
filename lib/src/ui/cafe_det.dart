import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ui/hotel_det.dart';
import '../ui/bookcafe.dart';

class CafeDet extends StatefulWidget {
  final String image;
  final String name;
  final String loc;
  final String price;
  final String time;
  final String abt;
  final String id;
  final String menu;
  final String ppl;
  CafeDet(
      {this.image,
      this.name,
      this.loc,
      this.price,
      this.time,
      this.abt,
      this.id,
      this.menu,
      this.ppl});
  @override
  _CafeDetState createState() => _CafeDetState();
}

class _CafeDetState extends State<CafeDet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              foregroundDecoration: BoxDecoration(color: Colors.black26),
              height: 400,
              child: Image.network(widget.image, fit: BoxFit.cover)),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 16.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text(
                        "8.4/85 reviews",
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {},
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(32.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.timer,
                                      size: 16.0,
                                      color: Colors.grey,
                                    )),
                                    TextSpan(text: widget.time)
                                  ]),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      color: Colors.grey,
                                    )),
                                    TextSpan(text: widget.loc)
                                  ]),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "₹ " + widget.price,
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              Text(
                                "for " + widget.ppl + " people",
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: Colors.purple,
                          textColor: Colors.white,
                          child: Text(
                            "Book Table",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => BookCafe(
                            //               id: widget.id,
                            //               name: widget.name,
                            //             )));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewTables(
                                  id: widget.id,
                                  name: widget.name,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      _tabSection(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "DETAIL",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.purple,
                labelColor: Colors.purple,
                tabs: [
                  Tab(text: "About"),
                  Tab(text: "Menu"),
                  Tab(text: "Reviews"),
                ]),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              ListView(
                children: [
                  const SizedBox(height: 10.0),
                  Text(
                    widget.abt,
                    textAlign: TextAlign.justify,
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 14.0),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  // Text("Eat here"),
                  Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width * 0.90,
                    decoration: BoxDecoration(
                        image:
                            DecorationImage(image: NetworkImage(widget.menu))),
                  ),
                ],
              ),
              Container(
                  // height: 500,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("cafes")
                          .doc(widget.id)
                          .collection("cafe_reviews")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.40,
                              ),
                              CircularProgressIndicator()
                            ],
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,

                            //physics: NeverScrollableScrollPhysics(),
                            // physics: NeverScrollablePhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot review =
                                  snapshot.data.docs[index];
                              return reviewtile(review['name'], review['img'],
                                  review['review'], context);
                            },
                          );
                        }
                      })),
            ]),
          ),
        ],
      ),
    );
  }
}

class ViewTables extends StatelessWidget {
  final String id, name;

  const ViewTables({Key key, this.id, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("View Tables"),
        elevation: 0.2,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("provider")
            .doc(id)
            .collection("tables")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 6, right: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.network(
                              snapshot.data.docs[index].data()["table_img_url"],
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.docs[index]
                                      .data()["table_name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Row(
                                    children: [
                                      Text("₹ "),
                                      Text(
                                        '${snapshot.data.docs[index].data()["table_max_price"].toString()} ',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.red[900],
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(" "),
                                      snapshot.data.docs[index]
                                                  .data()["table_max_price"] >
                                              snapshot.data.docs[index]
                                                  .data()["table_offer_price"]
                                          ? Text(
                                              '${snapshot.data.docs[index].data()["table_offer_price"].toString()} ',
                                              style: TextStyle(
                                                  color: Colors.red[900],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : Text(""),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "Seating Capacity : ${snapshot.data.docs[index].data()["seating_capacity"].toString()}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MaterialButton(
                                      height: 30,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0.0,
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BookCafe(
                                              id: id,
                                              name: name,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Book Table",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
