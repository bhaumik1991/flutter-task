import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firbase_fabricjs/screen/landing_page.dart';
import 'package:flutter_firbase_fabricjs/screen/login.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if(Platform.isAndroid){
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(false);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  User result = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Fabric',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: result != null ? LandingPage(uid: result.uid) : LoginPage(),
    );
  }
}


