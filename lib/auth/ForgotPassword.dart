import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:imaginationevents/auth/Login.dart';
import 'package:imaginationevents/resources/UrlResource.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {

  var formkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                // image: DecorationImage(
                //     image: AssetImage("assets/image/brighttails_app_logo.png"),
                //     // fit: BoxFit.fill,
                //     alignment: Alignment.topCenter
                // ),
              ),
            ),
            Positioned(
              top: 50,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,

                child: Image.asset("assets/img/admin_logo.png"),

                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   // image: DecorationImage(
                //   //     image: AssetImage("assets/image/brighttails_app_logo.png"),
                //   //     // fit: BoxFit.fill,
                //   //     alignment: Alignment.topCenter
                //   // ),
                // ),
              ),
            ),

            Positioned(
                top: 30,
                left: 20,
                child: Card(
                  child: Column(
                    children: [

                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop(
                                MaterialPageRoute(builder: (context)=> Login())
                            );
                          },
                          child:
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(

                                Icons.arrow_back,

                              ),
                            ),
                          ),
                      ),

                    ],
                  ),
                )),

            Positioned(
                top: 290,
                child: Container(
                  height: 600,
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
                              height: 20,
                            ),
                            Center(
                              child: Text("Don't worry. Enter your email   " ,textAlign: TextAlign.center,
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
                                      // hintText: 'Enter Name',
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
                                      labelText: 'Enter Email',
                                      prefixIcon: Icon(Icons.email),

                                      labelStyle: TextStyle(

                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress,

                                  ),
                                ),
                              ],
                            ),



                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                                onTap: () async {
                                  if (formkey.currentState!.validate()) {
                                    var em = _email.text.toString(); // Get the email text
                                    Uri url = Uri.parse(UrlResourece.FORGOTUSERPASS); // API URL

                                    try {
                                      var response = await http.post(url, body: {
                                        "email": em,  // Use the email string
                                      });

                                      if (response.statusCode == 200) {
                                        var jsonResponse = jsonDecode(response.body);
                                        if (jsonResponse["status"] == "true") {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Password reset email sent successfully")),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(jsonResponse["messages"])),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Server error. Please try again.")),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Error: $e")),
                                      );
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
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),


                          ],
                        )),
                  ),
                ))
          ],

        ),),
    );
  }
}
