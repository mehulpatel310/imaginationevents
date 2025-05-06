import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/Organizer/OrganizerHome.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEvents extends StatefulWidget {
  Map<String, dynamic>? GetData;
  String? imgurl;

  EditEvents({super.key, this.GetData, this.imgurl});

  @override
  State<EditEvents> createState() => _EditEventsState();
}

class _EditEventsState extends State<EditEvents> {
  TextEditingController eventorgid = TextEditingController();
  TextEditingController eventid = TextEditingController();
  TextEditingController cityid = TextEditingController();
  TextEditingController eventtitle = TextEditingController();
  TextEditingController atraction = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController pcode = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longtitude = TextEditingController();

  // TextEditingController isaprove = TextEditingController();
  TextEditingController startdate = TextEditingController();
  TextEditingController starttime = TextEditingController();
  TextEditingController enddate = TextEditingController();
  TextEditingController endtime = TextEditingController();

  File? photo1 = null;
  File? photo2 = null;
  File? photo3 = null;
  File? cphoto = null;

  List<dynamic> stateData = [];
  var state;
  Future<List<dynamic>?>? data;

  Future<List<dynamic>?>? getstatedata() async {
    Uri uri = Uri.parse(UrlResourece.ALLSTATEDATA);
    var responce = await http.get(uri);
    if (responce.statusCode == 200) {
      var body = jsonDecode(responce.body);
      setState(() {
        stateData = body['data'];
      });
    } else {
      print("api error");
    }
  }

  List<dynamic> cityData = [];
  List<dynamic> filtercityData = [];
  var city;
  Future<List<dynamic>?>? alldata;

  Future<List<dynamic>?>? getcitydata() async {
    Uri uri = Uri.parse(UrlResourece.ALLCITYDATA);
    var responce = await http.get(uri);
    if (responce.statusCode == 200) {
      var body = jsonDecode(responce.body);
      setState(() {
        cityData = body['data'];
        filtercityData = cityData;
      });
    } else {
      print("api error");
    }
  }

  //for events data
  List<dynamic> eventsData = [];
  var events;
  Future<List<dynamic>?>? allevetsdata;

  Future<List<dynamic>?> geteventsdata() async {
    Uri uri = Uri.parse(UrlResourece.ALLEVENTSDATA);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      setState(() {
        eventsData = body['data'];
        final String selectedEventId =
            widget.GetData!["event_cat_id"].toString();

        // Print eventsData to check the structure
        print("eventsData = $eventsData");

        bool exists = eventsData.any((event) {
          // Ensure both event_cat_id and selectedEventId are of the same type
          return event['event_cat_id'].toString() == selectedEventId;
        });

        print("exists = $exists");
        print("selectedEventId = $selectedEventId");

        if (exists) {
          events = selectedEventId;
        }

        // Print event IDs from the eventsData
        for (var row in eventsData) {
          print("ev id = ${row['event_id']}");
        }
      });
    } else {
      print("API error");
    }
  }

  var cphotoimg = "";
  var photo1img = "";
  var photo2img = "";
  var photo3img = "";

  //for organizer data
  List<dynamic> orgData = [];
  var org;
  Future<List<dynamic>?>? allorgdata;
  Future<List<dynamic>?>? getorgdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   org= prefs.getString("orgid") ?? "";
    print("org_id = $org");
    Uri uri = Uri.parse(UrlResourece.ALLORGDATA);
    var responce = await http.get(uri);
    if (responce.statusCode == 200) {
      var body = jsonDecode(responce.body);
      setState(() {
        orgData = body['data'];
      });
    } else {
      print("api error");
    }
  }

  var ename = "";

  geteventdata() async {
    print("getdata = ${widget.GetData}");

    setState(() {
      eventtitle.text = widget.GetData!["event_title"].toString();
      atraction.text = widget.GetData!["special_attraction"].toString();
      description.text = widget.GetData!["description"].toString();
      address1.text = widget.GetData!["address_line_1"].toString();
      address2.text = widget.GetData!["address_line_2"].toString();
      pcode.text = widget.GetData!["postcode"].toString();
      latitude.text = widget.GetData!["latitude"].toString();
      longtitude.text = widget.GetData!["longtitude"].toString();
      // longtitude.text = widget.GetData!["postcode"].toString();
      startdate.text = widget.GetData!["event_start_date"].toString();
      starttime.text = widget.GetData!["event_start_time"].toString();
      enddate.text = widget.GetData!["event_end_date"].toString();
      endtime.text = widget.GetData!["event_end_time"].toString();
      city = widget.GetData!["city_id"].toString();
      state = widget.GetData!["state_id"].toString();
      events = widget.GetData!["event_id"].toString();
      // photo1 = widget.GetData!["img_1"].toString() as File?;
      cphotoimg = widget.GetData!["cover_photo"];
      photo1img = widget.GetData!["photo_1"];
      photo2img = widget.GetData!["photo_2"];
      photo3img = widget.GetData!["photo_3"];
      // if (imagePath != null && imagePath.isNotEmpty) {
      //   photo1 = File(imagePath);
      // }
      // photo2 = widget.GetData!["postcode"].toString();
      // photo3.text = widget.GetData!["postcode"].toString();
      // cphoto.text = widget.GetData!["postcode"].toString();

      // eventtitle.text = ename;

      // print("ename = ${ename}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    geteventdata();
    geteventsdata();
    setState(() {
      alldata = getcitydata();
      data = getstatedata();
      // geteventsdata();
      allorgdata = getorgdata();
    });
  }

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
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
                            Navigator.of(context).pop(MaterialPageRoute(
                                builder: (context) => OrganizerHome()));
                          },
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  // Adds some space around the icon
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    // Set your desired background color
                                    shape: BoxShape
                                        .circle, // Makes the background circular
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 30,
                                  )),
                              SizedBox(width: 60),
                              Text(
                                "Edit Events",
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
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Select State:",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(height: 5),
                                      // Space between text and dropdown
                                      stateData.isNotEmpty
                                          ? DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Select State',
                                                filled: true,
                                                // fillColor: Colors.amberAccent,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                // labelText: 'Enter Email',
                                                prefixIcon:
                                                    Icon(Icons.my_location),

                                                labelStyle: TextStyle(
                                                  color: Colors.purple,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              value: state != null &&
                                                      state
                                                          .toString()
                                                          .isNotEmpty
                                                  ? state
                                                  : null,
                                              // Ensures hint text shows when nothing is selected
                                              items: stateData.map((value) {
                                                return DropdownMenuItem<String>(
                                                  value: value['state_id'],
                                                  child:
                                                      Text(value['state_name']),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                setState(() {
                                                  state = val!;
                                                  print("state = ${state}");
                                                  city = null;
                                                  filtercityData = cityData
                                                      .where((c) =>
                                                          c["state_id"] ==
                                                          state)
                                                      .toList();
                                                  print(
                                                      "filtercityData = ${filtercityData}");
                                                });
                                              },
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Select City:",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(height: 5),
                                      // Space between text and dropdown
                                      filtercityData.isNotEmpty
                                          ? DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Select City',
                                                filled: true,
                                                // fillColor: Colors.amberAccent,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                // labelText: 'Enter Email',
                                                prefixIcon:
                                                    Icon(Icons.location_city),

                                                labelStyle: TextStyle(
                                                  color: Colors.purple,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              value: city != null &&
                                                      city.toString().isNotEmpty
                                                  ? city
                                                  : null,
                                              // Ensures hint text shows when nothing is selected
                                              items:
                                                  filtercityData.map((value) {
                                                return DropdownMenuItem<String>(
                                                  value: value['city_id'],
                                                  child:
                                                      Text(value['city_name']),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                setState(() {
                                                  city = val!;
                                                  print("city = ${city}");
                                                });
                                              },
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Text("Event Id :",style: TextStyle(color: Colors.black),),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Select Events:",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(height: 5),
                                      // Space between text and dropdown
                                      eventsData.isNotEmpty
                                          ? DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Select Events',
                                                filled: true,
                                                // fillColor: Colors.amberAccent,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                // labelText: 'Enter Email',
                                                prefixIcon: Icon(Icons.event),

                                                labelStyle: TextStyle(
                                                  color: Colors.purple,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // value: events != null && events.toString().isNotEmpty
                                              //     ? events
                                              //     : null, // Ensures hint text shows when nothing is selected
                                              value: events != null &&
                                                      events
                                                          .toString()
                                                          .isNotEmpty
                                                  ? events
                                                  : null,
                                              items: eventsData.map((value) {
                                                return DropdownMenuItem<String>(
                                                  value: value['event_cat_id'],
                                                  child: Text(
                                                      value['event_cat_name']),
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
                                SizedBox(
                                  height: 10,
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Event Title :",
                                  style: TextStyle(color: Colors.black),
                                ),
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
                                    hintText: 'Enter Event Title',
                                    filled: true,
                                    // fillColor: Colors.amberAccent,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    // labelText: 'Enter Password',
                                    prefixIcon: Icon(Icons.title),

                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller: eventtitle,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Special Attraction :",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
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
                                    hintText: 'Enter Special Attraction',
                                    filled: true,
                                    // fillColor: Colors.amberAccent,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    // labelText: 'Enter Number',
                                    prefixIcon: Icon(Icons.type_specimen),

                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller: atraction,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Description :",
                                  style: TextStyle(color: Colors.black),
                                ),
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
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
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
                                  height: 20,
                                ),
                                Text(
                                  "Address Line 1 :",
                                  style: TextStyle(color: Colors.black),
                                ),
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
                                    hintText: 'Enter Address 1',
                                    filled: true,
                                    // fillColor: Colors.amberAccent,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    // labelText: 'Enter Gender',
                                    prefixIcon: Icon(Icons.details_sharp),

                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller: address1,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Address Line 2 :",
                                  style: TextStyle(color: Colors.black),
                                ),
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
                                    hintText: 'Enter Address 2',
                                    filled: true,
                                    // fillColor: Colors.amberAccent,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    // labelText: 'Enter Gender',
                                    prefixIcon: Icon(Icons.details_sharp),

                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller: address2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Post Code :",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
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
                                    hintText: 'Enter Post Code',
                                    filled: true,
                                    // fillColor: Colors.amberAccent,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    // labelText: 'Enter Gender',
                                    prefixIcon: Icon(Icons.share_location),

                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller: pcode,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "latitude :",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
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
                                    hintText: 'Enter latitude',
                                    filled: true,
                                    // fillColor: Colors.amberAccent,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    // labelText: 'Enter Gender',
                                    prefixIcon: Icon(Icons.location_on),

                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller: latitude,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "longtitude :",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
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
                                    hintText: 'Enter longtitude',
                                    filled: true,
                                    // fillColor: Colors.amberAccent,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    // labelText: 'Enter Gender',
                                    prefixIcon: Icon(Icons.location_on),

                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller: longtitude,
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                Text("Event Start Date:",
                                    style: TextStyle(color: Colors.black)),

                                TextFormField(
                                  controller: startdate,
                                  readOnly: true,
                                  // Prevent manual text input
                                  decoration: InputDecoration(
                                    hintText: 'Enter Start Date',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    prefixIcon: Icon(Icons.calendar_today),
                                    // Calendar icon
                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please select a start date";
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      startdate.text = DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                    }
                                  },
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                Text("Event Start Time:",
                                    style: TextStyle(color: Colors.black)),

                                TextFormField(
                                  controller: starttime,
                                  readOnly: true,
                                  // Prevent manual text input
                                  decoration: InputDecoration(
                                    hintText: 'Enter Start Time',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    prefixIcon: Icon(Icons.access_time),
                                    // Clock icon for time
                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please select a start time";
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      final now = DateTime.now();
                                      final selectedTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedTime.hour,
                                          pickedTime.minute);
                                      starttime.text = DateFormat('hh:mm a')
                                          .format(
                                              selectedTime); // Format as AM/PM
                                    }
                                  },
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                Text("Event End Date:",
                                    style: TextStyle(color: Colors.black)),

                                TextFormField(
                                  controller: enddate,
                                  readOnly: true,
                                  // Prevent manual text input
                                  decoration: InputDecoration(
                                    hintText: 'Enter End Date',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    prefixIcon: Icon(Icons.calendar_today),
                                    // Changed icon to calendar
                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please select an end date";
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      enddate.text = DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                    }
                                  },
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                Text("Event End Time:",
                                    style: TextStyle(color: Colors.black)),

                                TextFormField(
                                  controller: endtime,
                                  readOnly: true,
                                  // Prevent manual text input
                                  decoration: InputDecoration(
                                    hintText: 'Enter End Time',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    prefixIcon: Icon(Icons.access_time),
                                    // Changed icon to clock
                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please select an end time";
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      final now = DateTime.now();
                                      final formattedTime =
                                          DateFormat('hh:mm a').format(
                                        DateTime(now.year, now.month, now.day,
                                            pickedTime.hour, pickedTime.minute),
                                      );
                                      endtime.text = formattedTime;
                                    }
                                  },
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                Text("Cover Photo:",
                                    style: TextStyle(color: Colors.black)),
                                // Text("Cphoto ${cphoto}"),
                                // Text("cphotoimg ${cphotoimg}"),
                                (cphoto == null)
                                    ? Image.network(
                                        UrlResourece.EVENTS + cphotoimg!,
                                        width: 100.0,
                                        height: 100,
                                      )
                                    : Image.file(
                                        cphoto!,
                                        width: 100.0,
                                        height: 100,
                                      ),
                                TextFormField(
                                  readOnly: true,
                                  // controller: cphoto,
                                  onTap: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    XFile? photo = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    setState(() {
                                      cphoto = File(photo!.path);
                                    });

                                    // final ImagePicker _picker = ImagePicker();
                                    // final XFile? image = await _picker.pickImage(
                                    //   source: ImageSource.gallery,
                                    //   imageQuality: 85,
                                    // );
                                    //
                                    // if (image != null) {
                                    //   setState(() {
                                    //     cphoto.text = path.basename(image.path); // Store only the file name
                                    //   });
                                    // }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Choose Cover Photo (jpg, jpeg)',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    prefixIcon: Icon(Icons.image),
                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                                Text("Photo 1:",
                                    style: TextStyle(color: Colors.black)),
                                (photo1 == null)
                                    ? Image.network(
                                        UrlResourece.EVENTS + photo1img!,
                                        width: 100.0,
                                        height: 100,
                                      )
                                    : Image.file(
                                        photo1!,
                                        width: 100.0,
                                        height: 100,
                                      ),
                                TextFormField(
                                  readOnly: true,
                                  // controller: photo1,
                                  onTap: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    XFile? photo = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    setState(() {
                                      photo1 = File(photo!.path);
                                    });

                                    // final ImagePicker _picker = ImagePicker();
                                    // final XFile? image = await _picker.pickImage(
                                    //   source: ImageSource.gallery,
                                    //   imageQuality: 85,
                                    // );
                                    //
                                    // if (image != null) {
                                    //   setState(() {
                                    //     photo1.text = path.basename(image.path); // Store only the file name
                                    //   });
                                    // }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Choose Photo (jpg, jpeg)',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    prefixIcon: Icon(Icons.image),
                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return "Please select a photo";
                                  //   }
                                  //   return null;
                                  // },
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                Text("Photo 2:",
                                    style: TextStyle(color: Colors.black)),
                                (photo2 == null)
                                    ? Image.network(
                                        UrlResourece.EVENTS + photo2img!,
                                        width: 100.0,
                                        height: 100,
                                      )
                                    : Image.file(
                                        photo2!,
                                        width: 100.0,
                                        height: 100,
                                      ),
                                TextFormField(
                                  readOnly: true,
                                  // controller: photo2,
                                  onTap: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    XFile? photo = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    setState(() {
                                      photo2 = File(photo!.path);
                                    });
                                    // final ImagePicker _picker = ImagePicker();
                                    // final XFile? image = await _picker.pickImage(
                                    //   source: ImageSource.gallery,
                                    //   imageQuality: 85,
                                    // );
                                    //
                                    // if (image != null) {
                                    //   setState(() {
                                    //     photo2.text = path.basename(image.path); // Store only the file name
                                    //   });
                                    // }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Choose Photo (jpg, jpeg)',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    prefixIcon: Icon(Icons.image),
                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Photo 3:",
                                    style: TextStyle(color: Colors.black)),
                                (photo3 == null)
                                    ? Image.network(
                                        UrlResourece.EVENTS + photo3img!,
                                        width: 100.0,
                                        height: 100,
                                      )
                                    : Image.file(
                                        photo3!,
                                        width: 100.0,
                                        height: 100,
                                      ),
                                TextFormField(
                                  readOnly: true,
                                  // controller: photo3,
                                  onTap: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    XFile? photo = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    setState(() {
                                      photo3 = File(photo!.path);
                                    });

                                    // final ImagePicker _picker = ImagePicker();
                                    // final XFile? image = await _picker.pickImage(
                                    //   source: ImageSource.gallery,
                                    //   imageQuality: 85,
                                    // );
                                    //
                                    // if (image != null) {
                                    //   setState(() {
                                    //     photo3.text = path.basename(image.path); // Store only the file name
                                    //   });
                                    // }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Choose Photo (jpg, jpeg)',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    prefixIcon: Icon(Icons.image),
                                    labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (formkey.currentState!.validate()) {
                                      // var eorgid = eventorgid.text.toString();
                                      // var eid = eventid.text.toString();
                                      // var cid = cityid.text.toString();
                                      var title = eventtitle.text.toString();
                                      var atrac = atraction.text.toString();
                                      var desc = description.text.toString();
                                      var add1 = address1.text.toString();
                                      var add2 = address2.text.toString();
                                      var code = pcode.text.toString();
                                      var lati = latitude.text.toString();
                                      var longti = longtitude.text.toString();
                                      // var aprove = isaprove.text.toString();
                                      var sd = startdate.text.toString();
                                      var st = starttime.text.toString();
                                      var ed = enddate.text.toString();
                                      var et = endtime.text.toString();
                                      // var p1 = photo1.text.toString();
                                      // var p2 = photo2.text.toString();
                                      // var p3 = photo3.text.toString();

                                      var eid = widget.GetData!["event_id"];
                                      print("eid = $eid");

                                      print("eorgid = ${org.toString()}");
                                      print("city = ${city.toString()}");
                                      print("events = ${events.toString()}");
// print("eorgid = ${title}");

                                      Uri url =
                                          Uri.parse(UrlResourece.UPDATEEVENTS);
                                      var request =
                                          http.MultipartRequest("POST", url);
                                      request.fields['org_id'] = org.toString();
                                      request.fields['event_title'] = title;
                                      request.fields['event_cat_id'] =
                                          events.toString();
                                      request.fields['special_attraction'] =
                                          atrac;
                                      request.fields['description'] = desc;
                                      request.fields['address_line_1'] = add1;
                                      request.fields['address_line_2'] = add2;
                                      request.fields['city_id'] =
                                          city.toString();
                                      request.fields['postcode'] = code;
                                      request.fields['latitude'] = lati;
                                      request.fields['longtitude'] = longti;
                                      // request.fields['is_aprove'] = aprove;
                                      request.fields['event_start_date'] = sd;
                                      request.fields['event_start_time'] = st;
                                      request.fields['event_end_date'] = ed;
                                      request.fields['event_end_time'] = et;
                                      request.fields['event_id'] = eid;

                                      // print("Cover Image: ${cphoto!.path}");
                                      // print("Image 1: ${photo1!.path}");
                                      // print("Image 2: ${photo2!.path}");
                                      // print("Logo: ${photo3!.path}");



                                      print("eventtitle = ${request.fields['event_title']}");
                                      print("eventtitle = ${request.fields['event_cat_id']}");
                                      print("eventtitle = ${request.fields['special_attraction']}");
                                      print("eventtitle = ${request.fields['description']}");
                                      print("eventtitle = ${request.fields['address_line_1']}");
                                      print("eventtitle = ${request.fields['address_line_2']}");
                                      print("eventtitle = ${request.fields['city_id']}");
                                      print("eventtitle = ${request.fields['postcode']}");
                                      print("eventtitle = ${request.fields['latitude']}");
                                      print("eventtitle = ${request.fields['longtitude']}");
                                      print("eventtitle = ${request.fields['event_start_date']}");
                                      print("eventtitle = ${request.fields['event_start_time']}");
                                      print("eventtitle = ${request.fields['event_end_date']}");
                                      print("eventtitle = ${request.fields['event_end_time']}");
                                      print("eventtitle = ${request.fields['event_id']}");
                                      print(
                                          "eorgid = ${request.fields['org_id']}");
                                      // print("eorgid = ${request.fields['event_cat_id']}");

                                     if(cphoto!=null)
                                       {

                                         print("object data");
                                         var stream =
                                         http.ByteStream(cphoto!.openRead());
                                         var length = await cphoto!.length();

                                         var multipartFile = http.MultipartFile(
                                           'coverimg',
                                           stream,
                                           length,
                                           filename: cphoto!.path.split("/").last,
                                         );

                                         request.files.add(multipartFile);
                                       }
                                      if (photo1 != null) {
                                        var stream1 = http.ByteStream(photo1!.openRead());
                                        var length1 = await photo1!.length();
                                        var multipartFile1 = http.MultipartFile(
                                          'cimg1',
                                          stream1,
                                          length1,
                                          filename: photo1!.path.split("/").last,
                                        );
                                        request.files.add(multipartFile1);
                                      }

                                      if (photo2 != null) {
                                        var stream2 = http.ByteStream(photo2!.openRead());
                                        var length2 = await photo2!.length();
                                        var multipartFile2 = http.MultipartFile(
                                          'cimg2',
                                          stream2,
                                          length2,
                                          filename: photo2!.path.split("/").last,
                                        );
                                        request.files.add(multipartFile2);
                                      }

                                      if (photo3 != null) {
                                        var stream3 = http.ByteStream(photo3!.openRead());
                                        var length3 = await photo3!.length();
                                        var multipartFile3 = http.MultipartFile(
                                          'clogo',
                                          stream3,
                                          length3,
                                          filename: photo3!.path.split("/").last,
                                        );
                                        request.files.add(multipartFile3);
                                      }

                                      var response = await request.send();

                                      // Read response only ONCE
                                      var responseBody =
                                          await http.Response.fromStream(
                                              response);
                                      print(
                                          "Response Code: ${response.statusCode}");
                                      print(
                                          "Response Body: ${responseBody.body}");

                                      if (response.statusCode == 200) {
                                        if (responseBody.body.trim() == "yes") {
                                          print("Data inserted successfully");
                                        } else {
                                          print("Data not inserted");
                                        }
                                      } else {
                                        print("Error: ${response.statusCode}");
                                      }

                                      // 200 ok
                                      //400 no found
                                      //500 sever

                                      // var parms = {
                                      //   "org_id":org.toString(),
                                      //   "event_title":events.toString(),
                                      //   "event_cat_id":eid,
                                      //   "special_attraction":title,
                                      //   "cover_photo":atrac,
                                      //   "description":desc,
                                      //   "address_line_1":add1,
                                      //   "address_line_2":add2,
                                      //   "city_id":city.toString(),
                                      //   "postcode":code,
                                      //   "latitude":lati,
                                      //   "longtitude":longti,
                                      //   "is_aprove":aprove,
                                      //   "event_start_date":sd,
                                      //   "event_start_time":st,
                                      //   "event_end_date":ed,
                                      //   "event_end_time":et,
                                      //   "photo_1":p1,
                                      //   "photo_2":p2,
                                      //   "photo_3":p3,
                                      //   // "city_id":ci
                                      // };
                                      //
                                      // print("parms = ${parms}");
                                      // Uri url = Uri.parse(UrlResourece.ADDEVENTS);
                                      //
                                      // print("uri = ${url}");
                                      // var responce = await http.post(url,body: parms);
                                      // print("responce = ${responce.statusCode}");
                                      //
                                      // if(responce.statusCode==200)
                                      // {
                                      //   var body = responce.body.toString();
                                      //   print("body = ${body}");
                                      //   var json = jsonDecode(body);
                                      //   print("json = ${json}");
                                      //
                                      //   if(json["status"]=="true")
                                      //   {
                                      //     var msg = json["messages"].toString();
                                      //     print(msg);
                                      //   }
                                      //   else
                                      //   {
                                      //     var msg = json["messages"].toString();
                                      //     print(msg);
                                      //   }
                                      //
                                      // }
                                      // else
                                      // {
                                      //   print("Api Error!");
                                      // }

                                      // var cpass = cpassword.text.toString();

                                      // print(nm);
                                      // print(em);
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    margin: EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
                  )),
            ],
          );
        }),
      ),
    );
  }
}
