import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:imaginationevents/common/Home.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Bookings extends StatefulWidget {

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {

  Future<List<dynamic>?>? alldata;

  // var img = UrlResourece.BOOKINGS;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<dynamic>?> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ui = prefs.getString("orgid") ?? "";

    print("org_id = $ui"); // Fixed print statement

    if (ui.isEmpty) {
      debugPrint("User ID is empty.");
      return [];
    }

    var params = {
      "org_id": ui,
    };

    Uri url = Uri.parse(UrlResourece.BOOKINGS);
    print("uri = $url");

    try {
      var response = await http.post(url, body: params);
      print("Response body: ${response.body}"); // Added for debugging

      if (response.statusCode == 200) {
        try {
          var jsonData = jsonDecode(response.body);
          print("json = ${json}");
          return jsonData["data"];
        } catch (e) {
          debugPrint("Invalid JSON response: ${response.body}");
          return [];
        }
      } else {
        debugPrint("API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      alldata = getdata();
    });
  }

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
                        IconButton(
                          onPressed: () { Navigator.of(context).pop(
                              MaterialPageRoute(builder: (context)=> Home())
                          );},
                          // style: IconButton.styleFrom(
                          //   backgroundColor: Colors.white,
                          // ),
                          icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                          style: IconButton.styleFrom(backgroundColor: Colors.white24),
                        ),
                        SizedBox(width: 20,),
                        Text(
                          "Bookings Lists",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Space between text and search bar
                  ],
                ),
              ),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: constraints.maxHeight - 80,
                  color: Colors.white,
                  child: FutureBuilder(
                    future: alldata,
                    builder: (context, snapshop) {
                      if (snapshop.hasData) {
                        if (snapshop.data!.length <= 0) {
                          return Center(child: Text("No Data"));
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.all(10),
                            itemCount: snapshop.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Card(
                                  color: Colors.orangeAccent,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 15),
                                                _buildLabelText("User Name:", snapshop.data![index]["name"]),
                                                SizedBox(height: 10),
                                                _buildLabelText("Event:", snapshop.data![index]["event_title"]),
                                                SizedBox(height: 10),
                                                _buildLabelText("Transaction No:", snapshop.data![index]["transection_no"]),
                                                SizedBox(height: 10),
                                                _buildLabelText("Amount:", snapshop.data![index]["amount"]),
                                                SizedBox(height: 10),
                                                _buildLabelText("Booking Date & Time:", snapshop.data![index]["booking_date_time"]),
                                                SizedBox(height: 15),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  Widget _buildLabelText(String label, dynamic value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 18, color: Colors.black),
        children: [
          TextSpan(
            text: "$label ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value?.toString() ?? "N/A",
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

}
