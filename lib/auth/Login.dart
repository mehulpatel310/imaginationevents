import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imaginationevents/auth/ForgotPassword.dart';
import 'package:imaginationevents/auth/SignUp.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/common/BottomNavigationPage.dart';
import 'package:imaginationevents/common/OrganizerUser.dart';
import 'package:imaginationevents/common/UserOtpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/UrlResource.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // final double buttonWidth = screenSize.width * 0.8;
    // final double fontSize = screenSize.width * 0.06;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            Container(
              decoration: BoxDecoration(
                // color: Color(0xfff8bbd0),
              ),
            ),
            Positioned(
              top: screenSize.height * 0.01,  // Adjust as needed
              left: screenSize.width * 0.05,  // Adjust as needed
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop(MaterialPageRoute(builder: (context) => OrganizerUser()));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    shape: BoxShape.circle, // Circular shape
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),


            Positioned(
              top: screenSize.height * 0.01,
              right: screenSize.width * 0.05,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  BottomNavigationPage()));
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,

                child: Image.asset("assets/img/admin_logo.png"),

                decoration: BoxDecoration(
                  // color: Color(0xfff8bbd0),
                  // image: DecorationImage(
                  //     image: AssetImage("assets/image/admin_logo.png"),
                  //     // fit: BoxFit.fill,
                  //     alignment: Alignment.topCenter
                  // ),
                ),
              ),
            ),
            Positioned(
                top: 210,
                child: Container(
                  height: 700,
                  width: MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),

                    child: Form(
                        key: formkey,

                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text("Welcome Back" ,textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                ),),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Text("Email : ",style: TextStyle(color: Colors.white),),
                            Row(
                              children: [
                                Flexible(
                                  child:
                                  TextFormField(

                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Please enter Email";
                                      }
                                      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(val)) {
                                        return "Enter a valid Email";
                                      }
                                      return null;
                                    },

                                    decoration: InputDecoration(
                                      hintText: 'Enter Email',
                                      filled: true,
                                      // fillColor: Colors.amberAccent,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      // labelText: 'Enter Email',
                                      prefixIcon: Icon(Icons.person),

                                      labelStyle: TextStyle(

                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    controller: email,
                                    keyboardType: TextInputType.emailAddress,

                                  ),
                                  // SizedBox(height: 10,),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text("Password : ",style: TextStyle(color: Colors.white),),
                            Row(
                              children: [
                                Flexible(
                                  child:
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Please enter password";
                                      }
                                      if (!RegExp(r'^\d{8}$').hasMatch(val)) {
                                        return "Password must be at least 8 characters long";
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Password',
                                      filled: true,
                                      // fillColor: Colors.amberAccent,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      // labelText: 'Enter Password',
                                      prefixIcon: Icon(Icons.key),

                                      labelStyle: TextStyle(

                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    controller: password,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end, // Aligns content to the right
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=> Forgotpassword())
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password ?",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () async{
                                if (formkey.currentState!.validate()) {
                                  var em = email.text.toString();
                                  var pass = password.text.toString();
                                  var parms = {
                                    "email":em,
                                    "password":pass,
                                  };

                                  print("parms = ${parms}");
                                  // Uri url = Uri.parse("http://192.168.206.112/brighttails/api/register.php"); this is my phone ip address
                                  // Uri url = Uri.parse("http://192.168.1.15/imaginationevents/api/login.php");
                                  Uri url = Uri.parse(UrlResourece.LOGIN);

                                  print("uri = ${url}");
                                  var responce = await http.post(url,body: parms);
                                  print("responce = ${responce.statusCode}");

                                  if(responce.statusCode==200)
                                  {
                                    var body = responce.body.toString();
                                    print("body = ${body}");
                                    var json = jsonDecode( responce.body.toString());
                                    print("json = ${json}");

                                    if(json["status"]=="true")
                                    {
                                      var msg = json["messages"].toString();
                                      print(msg);
                                      var id = json["data"]["user_id"].toString();
                                      var email = json["data"]["email"].toString();
                                      var mobile = json["data"]["mobile_no"].toString();
                                      var img = json["data"]["user_img"].toString();
                                      var name = json["data"]["name"].toString();
                                      var otpdata = json["data"]["otp"].toString();
                                      // print("id = ${id}");

                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString("userid", id.toString());
                                      prefs.setString("useremail", email.toString());
                                      prefs.setString("usermobile", mobile.toString());
                                      prefs.setString("username", name.toString());
                                      prefs.setString("userimg", img.toString());
                                      prefs.setString("otpdata", otpdata.toString());
                                      prefs.setString("islogin", "yes");

                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>UserOtpScreen())
                                      );
                                      Fluttertoast.showToast(
                                          msg: msg.toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    }
                                    else
                                    {
                                      var msg = json["messages"].toString();
                                      print(msg);
                                      Fluttertoast.showToast(
                                          msg: msg.toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    }

                                  }
                                  else
                                  {
                                    print("Api Error!");
                                  }
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Ensures minimal height
                                children: [
                                  Text(
                                    "Not have an account?",style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=> SignUp())
                                      );
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                          ],
                        )),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
