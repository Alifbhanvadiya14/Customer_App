import 'dart:collection';

import 'package:Service/provider/location_provider.dart';
import 'package:Service/services/google_map_page.dart';
import 'package:Service/src/splash/splash.dart';
import 'package:Service/src/ui/boarding/enterphone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './src/ui/cafeapp.dart';
import './src/ui/homePage.dart';
import './src/splash/splash_screens.dart';
import './src/Constant/Constant.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
        create: (context) => LocationProvider(),
        child:
  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flipkart',
        theme: ThemeData(
          primaryColor: Color(0xff2874F0),
        ),
        routes: <String, WidgetBuilder>{
          SPLASH_SCREEN: (BuildContext context) => AnimatedSplashScreen(),
          HOME_SCREEN: (BuildContext context) => HomePage(),
        },
        home: Splashscreen(),
      ),

    );
  }
  
}
