import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import './hotel_det.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelList extends StatefulWidget {
  @override
  _HotelListState createState() => _HotelListState();
}

class _HotelListState extends State<HotelList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Hotel Booking",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.location_on,
              size: 20,
            ),
          ),
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
                            'Search for Hotels',
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
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance
              .collection("provider").where("provider_type",isEqualTo: "hotel") 
                    
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.40,
                        ),
                        CircularProgressIndicator()
                      ],
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      // physics: NeverScrollablePhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot hotel = snapshot.data.docs[index];

                        // print(names);

                        return hoteltile(
                            hotel["hotel_name"],
                            4,
                            hotel["hotel_city"],
                            hotel["hotel_offer_price"],
                            hotel["hotel_img_url"],
                            hotel["hotel_about"],
                            hotel.id);
                      },
                    );
                  }
                }),

            // hoteltile("Holiday Inn", 4.5, "Goa", "3200",
            //     "https://media-cdn.tripadvisor.com/media/photo-s/16/3c/02/21/photo3jpg.jpg"),
            // hoteltile("ITC Grand", 4, "Goa", "4000",
            //     "https://r1imghtlak.mmtcdn.com/762e77a427ef11ea80020242ac110004.png?&output-quality=75&downsize=520:350&crop=520:350;2,0&output-format=jpg"),
            // hoteltile("Sarovar Portico", 5, "Goa", "5000",
            //     "https://r1imghtlak.mmtcdn.com/f95e972a48c011ea9ce50242ac110003.jpg?&output-quality=75&downsize=520:350&crop=520:350;0,20&output-format=jpg")
          ],
        ),
      ),
    );
  }

  Widget hoteltile(String name, double rate, String loc, String price,
      String img, String abt, String id) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HotelDet(
                        name: name,
                        price: price,
                        img: img,
                        rate: rate,
                        loc: loc,
                        hotelid: id,
                        abt: abt,
                      )));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Card(
            elevation: 10.0,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth, image: NetworkImage(img))),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8),
                    child: Text(
                      name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 16),
                    child: Column(
                      children: [
                        Text(
                          "₹ " + price,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Text(
                          "Per Night",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Row(
                  children: [
                    RatingBarIndicator(
                      rating: rate,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        size: 5,
                        color: Colors.grey,
                      ),
                      itemCount: 5,
                      itemSize: 15.0,
                      unratedColor: Colors.white,
                      direction: Axis.horizontal,
                    ),
                    Text("(" + rate.toString() + ")",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.grey)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 15,
                    ),
                    Text(
                      loc,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class HotelDetailsPage {}
