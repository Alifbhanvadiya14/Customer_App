import 'package:flutter/material.dart';
import '../ui/cartpg.dart';
import '../ui/dryclean_det.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ui/prod_det.dart';

class AllProd extends StatefulWidget {
  final String id;
  AllProd({this.id});
  @override
  _AllProdState createState() => _AllProdState();
}

class _AllProdState extends State<AllProd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Products",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Icon(
            Icons.location_on,
            size: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CartPg()));
              },
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
            Container(
                // height: 500,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .where('product_vendor', isEqualTo: widget.id)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.40),
                            CircularProgressIndicator()
                          ],
                        );
                      } else {
                        print("--------------------------------");
                        print(snapshot.data.docs.length);

                        return Container(
                          // height: MediaQuery.of(context).size.height / 2,
                          child: ListView.builder(
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,

                            physics: NeverScrollableScrollPhysics(),
                            // physics: NeverScrollablePhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              print(snapshot.data.docs.length);
                              DocumentSnapshot prod = snapshot.data.docs[index];

                              print(prod["product_name"]);

                              //return Container();

                              return buildItem(
                                  context,
                                  prod["product_name"],
                                  prod["product_sell_price"],
                                  prod["product_img_url"],
                                  prod["product_max_price"],
                                  prod["product_weight"]);
                            },
                          ),
                        );
                      }
                    })),
            //Fifthlist(),
          ],
        ),
      ),
    );
  }

  buildItem(BuildContext context, String title, int price, String img, int cp,
      int weight) {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProdDet(
                            title: title,
                            url: img,
                            quan: weight.toString(),
                            cp: cp,
                            sp: price,
                            tag: widget.id,
                          )));
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 3,
              child: Image.network(
                img,
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 4,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 20),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  cp == price
                      ? Text(
                          "₹ " + cp.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        )
                      : Row(
                          children: [
                            Text(
                              "₹ " + cp.toString() + " ",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Text(
                              "₹ " + price.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            )
                          ],
                        ),
                ],
              ),
            ],
          ),
        ]));
  }
}
