import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firbase_fabricjs/screen/login.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LandingPage extends StatefulWidget {
  final MyInAppBrowser browser = new MyInAppBrowser();
  final String uid;
  LandingPage({this.uid});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class MyInAppBrowser extends InAppBrowser{
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}

class _LandingPageState extends State<LandingPage> {

  var options = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(
        hideProgressBar: false,
        hideUrlBar: false
    ),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
            "LandingPage",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
              icon: Icon(Icons.exit_to_app),
              onPressed: (){
                FirebaseAuth.instance.signOut().then((res){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route <dynamic> route) => false);
                });
              }
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: (){
            widget.browser.openUrlRequest(
              urlRequest: URLRequest(url: Uri.parse('http://fabricjs.com/freedrawing')),
              options: options,
            );
          },
          child: Text(
              "Free Drawing",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
