import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:imaginationevents/Organizer/OrganizerLogin.dart';
import 'package:imaginationevents/resources/UrlResource.dart';

class OrgForgotPassword extends StatefulWidget {
  const OrgForgotPassword({super.key});

  @override
  State<OrgForgotPassword> createState() => _OrgForgotPasswordState();
}

class _OrgForgotPasswordState extends State<OrgForgotPassword> {
  var formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
            ),
            Positioned(
              top: 50,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/img/admin_logo.png"),
              ),
            ),
            Positioned(
              top: 30,
              left: 20,
              child: Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OrganizerLogin()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 290,
              child: Container(
                height: 600,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Don't worry. Enter your email",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Email:", style: TextStyle(color: Colors.white)),
                        TextFormField(
                          // validator: (val) {
                          //   if (val == null || val.isEmpty) {
                          //     return "Please enter Email";
                          //   }
                          //   if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$').hasMatch(val)) {
                          //     return "Enter a valid Email";
                          //   }
                          //   return null;
                          // },
                          decoration: InputDecoration(
                            filled: true,
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
                            prefixIcon: Icon(Icons.email),
                            labelStyle: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              var em = _emailController.text.toString(); // Get the email text

                              print("email = $em");
                              Uri url = Uri.parse(UrlResourece.FORGOTORGPASS); // API URL

                              print("url = $url");

                              try {
                                var response = await http.post(url, body: {
                                  "email_id": em,  // Use the email string
                                });

                                print("responce = ${response.statusCode}");

                                if (response.statusCode == 200) {
                                  print("object");
                                  var body = response.body.toString();
                                  print("body = ${body}");
                                  var jsonResponse = jsonDecode(body);

                                  // print("json = ${jsonResponse}");
                                  print("json res = ${jsonResponse["status"]}");
                                  if (jsonResponse["status"] == "true") {

                                    print("Password reset email sent successfully");
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context)=>OrganizerLogin())
                                    );

                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(content: Text("Password reset email sent successfully")),
                                    // );
                                  } else {
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(content: Text(jsonResponse["messages"])),
                                    // );
                                    print("Password reset email Not sent successfully");
                                  }
                                } else {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(content: Text("Server error. Please try again.")),
                                  // );
                                  print("Server error. Please try again.");
                                }
                              } catch (e) {
                                print("error email");



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
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
