import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/Organizer/OrganizerLogin.dart';
import 'package:imaginationevents/resources/UrlResource.dart';

class OrgInquiry extends StatefulWidget {
  const OrgInquiry({super.key});

  @override
  State<OrgInquiry> createState() => _OrgInquiryState();
}

class _OrgInquiryState extends State<OrgInquiry> {
  TextEditingController name = TextEditingController();
  TextEditingController business = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController msg = TextEditingController();

  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:SafeArea(
        child: LayoutBuilder(
            builder: (context, constraints){
              return Stack(
                children: [
                  Container(
                    color: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop(
                                    MaterialPageRoute(builder: (context) => OrganizerLogin())
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10), // Adds some space around the icon
                                    decoration: BoxDecoration(
                                      color: Colors.white24, // Set your desired background color
                                      shape: BoxShape.circle, // Makes the background circular
                                    ),
                                    child: Icon(Icons.arrow_back, color: Colors.black,size: 30,),
                                  ),
                                  SizedBox(width: 60),
                                  Text(
                                    "Inquiry",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),

                      ],
                    ),
                  ),
                  Positioned(
                      top: 80,
                      bottom: 0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight - 80,
                        ),
                        child: SingleChildScrollView(
                          child: Container(
                            height:MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height,

                            // color: Colors.blueAccent,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(25)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: formkey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name :",style: TextStyle(color: Colors.black),),
                                    TextFormField(
                                      validator:(val){
                                        if (val == null || val.isEmpty) {
                                          return "Please enter Name";
                                        }
                                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) {
                                          return "Name should contain only letters";
                                        }
                                        return null;
                                      },

                                      decoration: InputDecoration(
                                        hintText: 'Enter Name',
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
                                        // labelText: 'Enter Name',
                                        prefixIcon: Icon(Icons.person),


                                        labelStyle: TextStyle(

                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller: name,
                                      keyboardType: TextInputType.text,

                                    ),
                                    SizedBox(height: 10,),
                                    Text("Business :" ,style: TextStyle(color: Colors.black),),
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      // obscureText: true,
                                      // validator: (val)
                                      // {
                                      //   if(val!.length<=0)
                                      //   {
                                      //     return "Please Enter password";
                                      //   }
                                      //   return null;
                                      // },
                                      decoration: InputDecoration(
                                        hintText: 'Enter Business',
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
                                        // labelText: 'Enter Gender',
                                        prefixIcon: Icon(Icons.description),

                                        labelStyle: TextStyle(

                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller: business,
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Email :",style: TextStyle(color: Colors.black),),
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
                                        prefixIcon: Icon(Icons.email),

                                        labelStyle: TextStyle(

                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller: email,
                                      keyboardType: TextInputType.emailAddress,

                                    ),
                                    SizedBox(height: 10,),
                                    Text("Mobile Number :",style: TextStyle(color: Colors.black),),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (val)
                                      {
                                        if (val == null || val.isEmpty) {
                                          return "Please enter mobile";
                                        }
                                        if (!RegExp(r'^[0-9]{10,15}$').hasMatch(val)) {
                                          return "Enter a valid phone number";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter Number',
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
                                        // labelText: 'Enter Number',
                                        prefixIcon: Icon(Icons.contact_page),

                                        labelStyle: TextStyle(

                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller: number,
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Massege :" ,style: TextStyle(color: Colors.black),),
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      // obscureText: true,
                                      // validator: (val)
                                      // {
                                      //   if(val!.length<=0)
                                      //   {
                                      //     return "Please Enter password";
                                      //   }
                                      //   return null;
                                      // },
                                      decoration: InputDecoration(
                                        hintText: 'Enter Massege',
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
                                        // labelText: 'Enter Gender',
                                        prefixIcon: Icon(Icons.description),

                                        labelStyle: TextStyle(

                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller: msg,
                                    ),
                                    SizedBox(height: 10,),

                                    InkWell(
                                      onTap: () async {
                                        if (formkey.currentState!.validate()) {
                                          var nm = name.text.trim();
                                          var bs = business.text.trim();
                                          var em = email.text.trim();
                                          var no = number.text.trim();
                                          var ms = msg.text.trim();

                                          var params = {
                                            "name": nm,
                                            "business": bs,
                                            "email": em,
                                            "contact": no,
                                            "msg": ms
                                          };

                                          print("Params: $params");
                                          Uri url = Uri.parse(UrlResourece.ADDIQUIRY);
                                          print("Request URL: $url");

                                          try {
                                            var response = await http.post(url, body: params);
                                            print("Response Status Code: ${response.statusCode}");

                                            if (response.statusCode == 200) {
                                              var body = response.body.toString();
                                              print("Response Body: $body");
                                              var json = jsonDecode(body);
                                              print("Parsed JSON: $json");

                                              if (json["status"] == "true") {
                                                var msg = json["messages"].toString();
                                                print(msg);
                                                Fluttertoast.showToast(
                                                  msg: "Success: $msg",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.green,
                                                  textColor: Colors.white,
                                                );
                                              } else {
                                                var msg = json["messages"].toString();
                                                print(msg);
                                                Fluttertoast.showToast(
                                                  msg: "Failed: $msg",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                );
                                              }
                                            } else {
                                              print("API Error!");
                                              Fluttertoast.showToast(
                                                msg: "Error: Server Issue (Code: ${response.statusCode})",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.orange,
                                                textColor: Colors.white,
                                              );
                                            }
                                          } catch (e) {
                                            print("Exception: $e");
                                            Fluttertoast.showToast(
                                              msg: "Network Error: $e",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 60,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        margin: EdgeInsets.all(10),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(color: Colors.white24, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),


                                    SizedBox(
                                      height: 10,
                                    ),



                                  ],
                                ),

                              ),
                            ),
                          ),
                        ),

                      )
                  ),

                ],
              );
            }
        ),
      ),
    );
  }
}
