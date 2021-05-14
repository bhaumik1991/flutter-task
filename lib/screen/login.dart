import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firbase_fabricjs/screen/landing_page.dart';
import 'package:flutter_firbase_fabricjs/screen/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Log In",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return "Enter email";
                      } else if(!value.contains('@')){
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return "Enter Password";
                      } else if(value.length < 6){
                        return 'Password must be atleast 6 characters!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        setState(() {
                          isLoading = true;
                        });
                        loginToFirebase();
                      }
                    },
                    child: Text("Log In"),
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Don't have an account?"
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.blue
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginToFirebase() {
    firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    ).then((result){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LandingPage(uid: result.user.uid,)),
              (Route<dynamic> route) => false);
    }).catchError((error){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Error"),
              content: Text(error.message),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")
                )
              ],
            );
          }
      );
    });
  }
}
