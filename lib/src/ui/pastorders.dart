import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PastOrders extends StatefulWidget {
  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {

   String name,email,phone,userId;

getPreFab() async{
  
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        
        userId  = prefs.getString("userId");

        name  = prefs.getString("username");
                email  = prefs.getString("email");

        phone  = prefs.getString("phone");


      });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Past Orders"),),
      body:  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("order-booking")
                          .where("user_id",isEqualTo: userId)
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
                            physics: NeverScrollableScrollPhysics(),
                            // physics: NeverScrollablePhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot booking = snapshot.data.docs[index];

                              // print(names);
if(booking["type"] == "vendor"){
     return vendorOrderCard(booking["vendor"], booking["order_amount"].toString(), booking["order_items"].toString(), booking["order_id"].toString(),booking["type"]);
}else if(booking["type"] == "hotel"){
       return hotelOrderCard(booking["hotel_name"], booking["total_amount"].toString(), booking["no_of_days"].toString(), booking["booking_id"].toString(), booking["type"], booking["start_date"], booking["end_date"], booking["room_type"], booking["guest_name"]);
}
else if(booking["type"] == "drycleaning"){
       return dryCleanOrderCard(booking["dryclean_shop_name"], booking["total_cost"].toString(), booking["no_of_clothes"].toString(), booking["booking_id"].toString(), booking["type"], booking["service_date"],booking["service_name"]);
}
                           
                            },
                          );
                        }
                      })
    );
  }



Widget vendorOrderCard(String vendor,String orderAmount, String orderItems,String orderId,String type){
  return Container(
    padding: EdgeInsets.only(top: 40,left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
  Text("Order Type: $type",style: detailsfont,),
  Text("Order ID: $orderId",style: detailsfont,),
        Text("Vendor: $vendor",style: detailsfont,),
          Text("Amount: $orderAmount",style: detailsfont,),
              Text("Items: $orderItems",style: detailsfont,),
                  
],
    ),
  );


}


Widget dryCleanOrderCard(String shopName,String orderAmount, String clothCount,String bookingID,String type,String serviceDate,String serviceName){
  return Container(
    padding: EdgeInsets.only(top: 40,left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
  Text("Order Type: $type",style: detailsfont,),
  Text("Order ID: $bookingID",style: detailsfont,),
        Text("DryCleaner: $shopName",style: detailsfont,),
          Text("Amount: $orderAmount",style: detailsfont,),
              Text("Items: $clothCount",style: detailsfont,),
                 Text("Package Name: $serviceName",style: detailsfont,),
                  
],
    ),
  );


}


Widget hotelOrderCard(String hotelname,String bookingamount, String noOfDays,String bookingId,String type,String startDate, String endDate,String roomType,String customerName){
  return Container(
    padding: EdgeInsets.only(top: 40,left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
                Text("Guest Name: $customerName",style: detailsfont,),

  Text("Order Type: $type",style: detailsfont,),
  Text("Booking ID: $bookingId",style: detailsfont,),
        Text("Hotel: $hotelname",style: detailsfont,),
          Text("Amount: $bookingamount",style: detailsfont,),
              Text("Days: $noOfDays",style: detailsfont,),
                 Text("Start Date: $startDate",style: detailsfont,),
              Text("Days: $endDate",style: detailsfont,),
                 Text("Room Type: $roomType",style: detailsfont,),
                  
],
    ),
  );


}

TextStyle detailsfont =TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400
);

}