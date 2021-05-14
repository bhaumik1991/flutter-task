import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firbase_fabricjs/screen/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference reference = FirebaseFirestore.instance.collection('users');

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
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
                    "Sign Up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Enter Username",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return "Enter Username";
                      }
                      return null;
                    },
                  ),
                ),
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
                        style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue)),
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            setState(() {
                              isLoading = true;
                            });
                          registerToFirebase();
                       }
                    },
                    child: Text("Sign Up"),
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?"
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                          "Login",
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

  void registerToFirebase() {
    firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    ).then((result) {
      reference.doc(firebaseAuth.currentUser.uid).set({
        "email" : emailController.text,
        "username" : usernameController.text
      }).then((res){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    }).catchError((error){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Error"),
              content: Text(error.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    });
  }
}
