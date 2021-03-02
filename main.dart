import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mbtsdriver/Widgets/dataprovider.dart';
import 'package:mbtsdriver/globalvariables.dart';
import 'package:mbtsdriver/screens/loginpage.dart';
import 'package:mbtsdriver/screens/mainpage.dart';
import 'package:mbtsdriver/screens/registrationpage.dart';
import 'dart:io';

import 'package:mbtsdriver/screens/vehicleinfo.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:297855924061:ios:c6de2b69b03a5be8',
      apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
      projectId: 'flutter-firebase-plugins',
      messagingSenderId: '297855924061',
      databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:223819509489:android:ca60878ec308eede4b0350',
      apiKey: 'AIzaSyDcxMKaXGYRg3UUMGqfhJk-IxJSrNup26g',
      messagingSenderId: '297855924061',
      projectId: 'flutter-firebase-plugins',
      databaseURL: 'https://mtbs-3ba2a-default-rtdb.firebaseio.com',
    ),
  );
  currentFirebaseUser=await FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>AppData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //initialRoute: (currentFirebaseUser==null)?LoginPage.id:MainPage.id,
        initialRoute: LoginPage.id,
        routes: {
          MainPage.id: (context)=>MainPage(),
          RegistrationPage.id: (context)=>RegistrationPage(),
          VehicleInfoPage.id: (context)=>VehicleInfoPage(),
          LoginPage.id:(context)=>LoginPage(),
        },
      ),
    );
  }
}


