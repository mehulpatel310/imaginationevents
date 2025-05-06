import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/common/AllCity.dart';
import 'package:imaginationevents/common/AllState.dart';
import 'package:imaginationevents/common/MyProfile.dart';
import 'package:imaginationevents/events/Events.dart';
import 'package:imaginationevents/events/EventsDetails.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<dynamic>?>? alldata;

  var img = UrlResourece.CATIMG;

  Future<List<dynamic>?>? getdata() async {
    Uri url = Uri.parse(UrlResourece.EVENTSCAT);

    print("uri = ${url}");
    var responce = await http.get(url);
    print("responce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("body = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");

      return json["data"];
    } else {
      print("Api Error!");
    }
  }

  //Ads data
  Future<List<dynamic>?>? adsdata;

  var imgasd = UrlResourece.ADSIMG;

  Future<List<dynamic>?>? dataads() async {
    Uri url = Uri.parse(UrlResourece.ALLADS);

    print("uri = ${url}");
    var responce = await http.get(url);
    print("responce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("body = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");

      return json["data"];
    } else {
      print("Api Error!");
    }
  }

//state data code
  Future<List<dynamic>?>? fechdata;
  var simg = UrlResourece.STATEIMG;

  Future<List<dynamic>?>? statedata() async {
    Uri surl = Uri.parse(UrlResourece.EVENTS_STATE);

    print("uri = ${surl}");
    var responce = await http.get(surl);
    print("responce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("body = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");

      return json["data"];
    } else {
      print("Api Error!");
    }
  }

  //EVENTS DATA FIRST 5
  Future<List<dynamic>?>? fach;

  var img1 = UrlResourece.EVENTS;

  Future<List<dynamic>?>? data() async {
    Uri url = Uri.parse(UrlResourece.ALLEVENTS);

    print("uri = ${url}");
    var responce = await http.get(url);
    print("responce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("body = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");

      return json["data"];
    } else {
      print("Api Error!");
    }
  }

  //EVENTS DATA LAST 5
  Future<List<dynamic>?>? lastfachdata;

  var imglast = UrlResourece.LASTEVENTS;

  Future<List<dynamic>?>? lastdata() async {
    Uri url = Uri.parse(UrlResourece.LAST_EVENTS);

    print("uri = ${url}");
    var responce = await http.get(url);
    print("responce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("body = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");

      return json["data"];
    } else {
      print("Api Error!");
    }
  }

  //ORG DATA
  Future<List<dynamic>?>? get;

  var img2 = UrlResourece.ORG;

  Future<List<dynamic>?>? orgdata() async {
    Uri url = Uri.parse(UrlResourece.ALLORGDATA);

    print("uri = ${url}");
    var responce = await http.get(url);
    print("responce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("body = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");

      return json["data"];
    } else {
      print("Api Error!");
    }
  }

  // TextEditingController _searchController = TextEditingController();

  var username = "";
  var islogin = "";
  var userimage = "";

  getuserdata()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username").toString();
      islogin = prefs.getString("islogin").toString();
      userimage = prefs.getString("userimg").toString();

      print("username  = ${username}");
      print("islogin  = ${islogin}");
      print("userimage  = ${userimage}");
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getuserdata();
      alldata = getdata();
      fechdata = statedata();
      fach = data();
      get = orgdata();
      adsdata = dataads();
      lastfachdata = lastdata();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                color: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Profile Avatar and Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Myprofile()), // Replace with your MyProfile screen
                                );
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: (islogin == "yes")
                                    ? NetworkImage(UrlResourece.USERIMG + userimage)
                                    : AssetImage('assets/img/img1.jpg') as ImageProvider,
                              ),
                            ),

                            SizedBox(width: 10),
                            // Space between avatar and text
                            (islogin=="yes")?Container(
                              // color: Colors.orangeAccent,
                              width: 280,
                              child: Text(
                                "Welcome ${username}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ):Text(
                              "Welcome User",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Notification Icon
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.notifications, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Divider(
              //   thickness: 10,
              //   color: Colors.green,
              //   height: 180,
              // ),
              //second container
              Positioned(
                top: 90,
                bottom: 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight - 160,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      // height: 650,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xffe0f7fa),

                      child: Container(
                        padding: new EdgeInsets.only(bottom: 10),
                        // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            //slidebar start
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    // Aligns text to the start
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                CarouselSlider(
                                  items: [
                                    //1st Image of Slider
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/img/img1.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    //2nd Image of Slider
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/img/img2.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    //3rd Image of Slider
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/img/img3.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],

                                  //Slider Container properties
                                  options: CarouselOptions(
                                    height: 210,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enableInfiniteScroll: true,
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 800),
                                    viewportFraction: 0.9,
                                  ),
                                ),
                              ],
                            ),

                            // SizedBox(height: 10,),
                            //recent event
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Recent Events",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 90,),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => Events(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "View All",
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blue,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(height: 30),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.only(bottom: 10),
                                            child: FutureBuilder(
                                              future: fach,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(child: CircularProgressIndicator());
                                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                  return Center(child: Text("No Data"));
                                                } else {
                                                  return SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children:
                                                      List.generate(snapshot.data!.length, (index) {
                                                        var Item = snapshot.data![index];
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => Eventsdetails(
                                                                  GetData: Item,
                                                                  imgurl: img1,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            width:
                                                            MediaQuery.of(context).size.width / 2.1,
                                                            margin:
                                                            EdgeInsets.symmetric(horizontal: 5),
                                                            child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                              color: Colors.white,
                                                              margin: EdgeInsets.all(8),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    width: double.infinity,
                                                                    height: 150,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Colors.blueAccent),
                                                                      borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top:
                                                                          Radius.circular(15)),
                                                                      color: Colors.white,
                                                                    ),
                                                                    child: Center(
                                                                      child: Image.network(
                                                                        img1 +
                                                                            snapshot.data![index]
                                                                            ["cover_photo"]
                                                                                .toString(),
                                                                        width: double.infinity,
                                                                        height: 100,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(10.0),
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          "${Item["event_title"]}",
                                                                          style: TextStyle(
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black,
                                                                          ),
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),


                            // SizedBox(height:10,),

                            //ads start
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(height: 30),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: FutureBuilder(
                                          future: adsdata,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return Center(
                                                  child: Text("No Data"));
                                            } else {
                                              return Row(
                                                children: List.generate(
                                                    snapshot.data!.length,
                                                    (index) {
                                                  var Item =
                                                      snapshot.data![index];
                                                  return InkWell(
                                                    onTap: () {
                                                      // Navigator.of(context).push(MaterialPageRoute(
                                                      //     builder: (context) => CartPage()));
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.10,
                                                      // Adjusted for better visibility
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 17),
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        elevation: 5,
                                                        color: Colors.white,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: Image.network(
                                                            imgasd +
                                                                Item["slider_img"]
                                                                    .toString(),
                                                            width:
                                                                double.infinity,
                                                            height: 200,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //event by state
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // Ensures everything aligns to the left
                                children: [
                                  // Title (Left-Aligned)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Events By State",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AllState(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "View All",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(width: 10),
                                  // FutureBuilder for API Data
                                  FutureBuilder(
                                    future: fechdata,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                            child: Text("No Data Available",
                                                style:
                                                    TextStyle(fontSize: 16)));
                                      } else {
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // Aligns cards to the start
                                            children: List.generate(
                                                snapshot.data!.length, (index) {
                                              var Item = snapshot.data![index];
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => AllCity(
                                                        GetData: Item["state_id"], // Pass the state_id to AllCity
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.3,
                                                  margin: EdgeInsets.only(
                                                      right: 10, bottom: 10),
                                                  // Adjust spacing
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 3),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    // Align text to start
                                                    children: [
                                                      // Event Category Image
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        15)),
                                                        child: Image.network(
                                                          simg +
                                                              Item["state_image"]
                                                                  .toString(),
                                                          width:
                                                              double.infinity,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Container(
                                                            height: 130,
                                                            color: Colors
                                                                .grey[300],
                                                            child: Center(
                                                                child: Icon(
                                                                    Icons
                                                                        .image_not_supported,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 50)),
                                                          ),
                                                        ),
                                                      ),

                                                      // Category Name
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          // Aligns text to left
                                                          children: [
                                                            Text(
                                                              Item[
                                                                  "state_name"],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              "Explore more events",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),

                            //last 5 start
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Featured Events",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 80,),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => Events(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "View All",
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blue,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Rest of your code remains unchanged
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.only(bottom: 10),
                                            child: FutureBuilder(
                                              future: lastfachdata,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(child: CircularProgressIndicator());
                                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                  return Center(child: Text("No Data"));
                                                } else {
                                                  return SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: List.generate(snapshot.data!.length, (index) {
                                                        var Item = snapshot.data![index];
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => Eventsdetails(
                                                                  GetData: Item,
                                                                  imgurl: imglast,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width / 2.1,
                                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                                            child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                              color: Colors.white,
                                                              margin: EdgeInsets.all(8),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    width: double.infinity,
                                                                    height: 150,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(color: Colors.blueAccent),
                                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                                                      color: Colors.white,
                                                                    ),
                                                                    child: Center(
                                                                      child: Image.network(
                                                                        imglast + snapshot.data![index]["cover_photo"].toString(),
                                                                        width: double.infinity,
                                                                        height: 100,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(10.0),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          "${Item["event_title"]}",
                                                                          style: TextStyle(
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black,
                                                                          ),
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // SizedBox(
                            //   height: 10,
                            // ),
                            //event org star
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          "Event Organizers",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 15),
                                      SizedBox(
                                        height: 280,
                                        // Adjusted for better proportions
                                        child: FutureBuilder(
                                          future: get,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return Center(
                                                  child: Text(
                                                      "No Data Available",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16)));
                                            } else {
                                              return ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  var item =
                                                      snapshot.data![index];
                                                  return InkWell(
                                                    onTap: () {
                                                      // Handle tap
                                                    },
                                                    child: Container(
                                                      width: 190,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 15),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            blurRadius: 10,
                                                            spreadRadius: 2,
                                                            offset:
                                                                Offset(3, 5),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                        ),
                                                        elevation: 3,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              18)),
                                                                  child: Image
                                                                      .network(
                                                                    img2 +
                                                                        item["company_logo"]
                                                                            .toString(),
                                                                    width: double
                                                                        .infinity,
                                                                    height: 130,
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                    errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) =>
                                                                        Container(
                                                                      color: Colors
                                                                              .grey[
                                                                          300],
                                                                      child: Icon(
                                                                          Icons
                                                                              .image_not_supported,
                                                                          size:
                                                                              80,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 130,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.vertical(
                                                                            top:
                                                                                Radius.circular(18)),
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .black54,
                                                                        Colors
                                                                            .transparent
                                                                      ],
                                                                      begin: Alignment
                                                                          .bottomCenter,
                                                                      end: Alignment
                                                                          .topCenter,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      12.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    item["company_name"] ??
                                                                        "",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          6),
                                                                  Text(
                                                                    item["name"] ??
                                                                        "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey[700]),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  // SizedBox(height: 6),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            //inquiry start
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    // Aligns text to the start
                                    child: Text(
                                      "Support",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                // Inquiry or Support Card
                                Card(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 5,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "For any Inquiry or Support",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(Icons.phone,
                                                color: Colors.blue),
                                            SizedBox(width: 10),
                                            Text(
                                              "+1 234 567 890",
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(Icons.email,
                                                color: Colors.red),
                                            SizedBox(width: 10),
                                            Text(
                                              "support@example.com",
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Helper function to build image containers
  Widget _buildImageContainer(String imagePath) {
    return Container(
      margin: EdgeInsets.all(6.0),
      width: 100, // Adjust width to fit three images in one slide
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
