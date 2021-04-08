import 'package:Service/provider/location_provider.dart';
import 'package:Service/services/google_map_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/cartpg.dart';
import '../ui/widgets/Drawerfile.dart';
import '../ui/body.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name, email, phone, userId;

  getPreFab() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");

      name = prefs.getString("username");
      email = prefs.getString("email");

      phone = prefs.getString("phone");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Container(
          color: Colors.green,
          child: Column(
            children: [
              AppBar(
                elevation: 0,
                title:
//

                    Text(
                  "BAKHEDA",
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoogleMapScreen()));
                    },
                    child: Icon(
                      Icons.location_on,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CartPg()));
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 70,
                color: Theme.of(context).primaryColor,
                child: Consumer<LocationProvider>(
                  builder: (context, model, child) {
                    if (model.selectedLocationStatic.name == null) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            width: MediaQuery.of(context).size.width,
                            // height: 40,
                            child: Text(
                              model.selectedLocationStatic.name,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            child: Text(
                              "Current Address",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Drawerfile(),
      ),
      body: Body(),
    );
  }
}
