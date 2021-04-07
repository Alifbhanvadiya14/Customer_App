import '../ui/prod_det.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ProdList extends StatefulWidget {
  final String tag;
  ProdList({this.tag});
  @override
  _ProdListState createState() => _ProdListState();
}

class _ProdListState extends State<ProdList> {
  // var name = [
  //   "https://images-na.ssl-images-amazon.com/images/I/71PiszDkulL._SL1500_.jpg",
  //   "https://www.bigbasket.com/media/uploads/p/l/284420_8-aashirvaad-multigrains-atta.jpg",
  //   "https://images-na.ssl-images-amazon.com/images/I/41XDxFG9WzL.jpg",
  //   "https://images-na.ssl-images-amazon.com/images/I/51R6OxZA-KL._SY450_.jpg",
  //   "https://images-na.ssl-images-amazon.com/images/I/61L1thSI95L._SL1000_.jpg"
  // ];
  // var quan = ["50 g", "1 kg", "1 kg", "1 kg", "500 g"];

  buildItem(BuildContext context, String title, int price, String img, int cp,
      int weight) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(
        children: [
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
                            tag: widget.tag,
                          )));
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 4,
              child: Image.network(
                img,
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 4,
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10),
          ),
          Text(
            "₹ " + price.toString(),
            style: TextStyle(color: Colors.green, fontSize: 10),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
              // height: 500,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .where('product_vendor', isEqualTo: widget.tag)
                      .snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (!snapshot.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.40),
                          CircularProgressIndicator()
                        ],
                      );
                    } else {
                      print("--------------------------------");
                      print(snapshot.data.docs.length);

                      return Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,

                          //physics: NeverScrollableScrollPhysics(),
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
        ],
      ),
    );
  }
}
