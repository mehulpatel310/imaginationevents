import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:imaginationevents/resources/UrlResource.dart';

class UpdateTeckets extends StatefulWidget {
  const UpdateTeckets({super.key});

  @override
  State<UpdateTeckets> createState() => _UpdateTecketsState();
}

class _UpdateTecketsState extends State<UpdateTeckets> {
  TextEditingController eventid = TextEditingController();
  TextEditingController ticketname = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController total = TextEditingController();

  //for events data
  List<dynamic> eventsData = [];
  var events;
  Future<List<dynamic>?>? allevetsdata;
  Future<List<dynamic>?>? geteventsdata()async{
    Uri uri = Uri.parse(UrlResourece.ALLEVENTSNAME);
    var responce = await http.get(uri);
    if (responce.statusCode == 200) {
      var body = jsonDecode(responce.body);
      setState(() {
        eventsData = body['data'];
      });
    } else {
      print("api error");
    }
  }

  var formkey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      allevetsdata =  geteventsdata();
    });
  }

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
                                // Navigator.of(context).pop(
                                //     MaterialPageRoute(builder: (context) => OrganizerHome())
                                // );
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
                                    "Update Tickets",
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
                                    // Center(child:
                                    // Text(
                                    //   "Create Your Account",
                                    //   textAlign: TextAlign.center,
                                    //   style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontSize: 26),
                                    // ),),
                                    // Text("Event Name :",style: TextStyle(color: Colors.black),),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Events:",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          SizedBox(height: 5), // Space between text and dropdown
                                          eventsData.isNotEmpty
                                              ? DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              hintText: 'Select Event',
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
                                              prefixIcon: Icon(Icons.event),

                                              labelStyle: TextStyle(

                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            value: events != null && events.toString().isNotEmpty
                                                ? events
                                                : null, // Ensures hint text shows when nothing is selected
                                            items: eventsData.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value['event_id'],
                                                child: Text(value['event_title']),
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                events = val!;
                                                print(events);
                                              });
                                            },
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Ticket Name :",style: TextStyle(color: Colors.black),),
                                    TextFormField(
                                      // validator: (val) {
                                      //   if (val == null || val.isEmpty) {
                                      //     return "Please enter Email";
                                      //   }
                                      //   if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(val)) {
                                      //     return "Enter a valid Email";
                                      //   }
                                      //   return null;
                                      // },
                                      decoration: InputDecoration(
                                        hintText: 'Enter Ticket Name',
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
                                        prefixIcon: Icon(Icons.card_membership),

                                        labelStyle: TextStyle(

                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller: ticketname,
                                      keyboardType: TextInputType.emailAddress,

                                    ),
                                    SizedBox(height: 10,),
                                    Text("Ticket Description :" ,style: TextStyle(color: Colors.black),),
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
                                        hintText: 'Enter Description',
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
                                      controller: description,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Ticket Price :",style: TextStyle(color: Colors.black),),
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      // validator: (val) {
                                      //   if (val == null || val.isEmpty) {
                                      //     return "Please enter password";
                                      //   }
                                      //   if (!RegExp(r'^\d{8}$').hasMatch(val)) {
                                      //     return "Password must be at least 8 characters long";
                                      //   }
                                      //   return null;
                                      // },
                                      // obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Price',
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
                                        prefixIcon: Icon(Icons.currency_rupee),

                                        labelStyle: TextStyle(

                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller: price,
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Total Tickets :",style: TextStyle(color: Colors.black),),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      // validator: (val)
                                      // {
                                      //   if (val == null || val.isEmpty) {
                                      //     return "Please enter mobile";
                                      //   }
                                      //   if (!RegExp(r'^[0-9]{10,15}$').hasMatch(val)) {
                                      //     return "Enter a valid phone number";
                                      //   }
                                      //   return null;
                                      // },
                                      decoration: InputDecoration(
                                        hintText: 'Enter Toatal Tickets',
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
                                        prefixIcon: Icon(Icons.tab),

                                        labelStyle: TextStyle(

                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller: total,
                                    ),
                                    SizedBox(height: 10,),

                                    InkWell(
                                      onTap: () async {
                                        if (formkey.currentState!.validate()) {
                                          var id = eventid.text.trim();
                                          var nm = ticketname.text.trim();
                                          var ds = description.text.trim();
                                          var pr = price.text.trim();
                                          var tl = total.text.trim();

                                          var params = {
                                            "event_id": events.toString(),
                                            "ticket_name": nm,
                                            "ticket_description": ds,
                                            "ticket_price": pr,
                                            "total_ticket": tl
                                          };

                                          print("Params: $params");
                                          Uri url = Uri.parse(UrlResourece.ADDTICKETS);
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
