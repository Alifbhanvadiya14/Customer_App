import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'bookmanpower.dart';

class ViewPackages extends StatelessWidget {
  final String manpowerId, name;

  const ViewPackages({Key key, this.manpowerId, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Packages"),
        elevation: 0.2,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("provider")
            .doc(manpowerId)
            .collection("packages")
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
                              snapshot.data.docs[index]
                                  .data()["package_img_url"],
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
                                      .data()["package_name"],
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
                                        '${snapshot.data.docs[index].data()["package_price"].toString()} / ${snapshot.data.docs[index].data()["package_price_unit"]}',
                                        style: TextStyle(
                                            color: Colors.red[900],
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    snapshot.data.docs[index]
                                        .data()["package_desc"],
                                    overflow: TextOverflow.ellipsis,
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
                                                builder: (_) => BookManpower(
                                                      id: manpowerId,
                                                      name: name,
                                                      packageSnapshot: snapshot
                                                          .data.docs[index],
                                                    )));
                                      },
                                      child: Text(
                                        "Book Now",
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
