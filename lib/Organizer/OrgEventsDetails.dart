import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/Organizer/EditEvents.dart';
import 'package:imaginationevents/Organizer/EditTickets.dart';
import 'package:imaginationevents/Organizer/OrganizerHome.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgEventsDetails extends StatefulWidget {
  Map<String, dynamic>? GetData;
  String? imgurl;


 OrgEventsDetails({super.key,this.GetData,this.imgurl});

  @override
  State<OrgEventsDetails> createState() => _OrgEventsDetailsState();
}

class _OrgEventsDetailsState extends State<OrgEventsDetails> {
  @override
  void initState() {
    super.initState();

    alldata = getdata();
  }

  Future<List<dynamic>?>? alldata;

  // var img = UrlResourece.EVENTS;

  Future<List<dynamic>?> getdata() async {
    print("object = ${widget.GetData}");
    Uri url = Uri.parse(UrlResourece.ORGEVENTSDETAILS);

    try {
      var response = await http.post(
        url,
        body: {
          'event_id': widget.GetData!["event_id"]
        }, // Send the category ID properly
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print("jsonData = ${jsonData["data"]}");
        return jsonData["data"] ?? []; // Ensure it's always a list
      } else {
        debugPrint("API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return [];
    }
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      UrlResourece.EVENTS + widget.GetData!["cover_photo"].toString(),
      UrlResourece.EVENTS + widget.GetData!["photo_1"].toString(),
      UrlResourece.EVENTS + widget.GetData!["photo_2"].toString(),
      UrlResourece.EVENTS + widget.GetData!["photo_3"].toString(),
    ];

    // print("img = ${UrlResourece.EVENTS'' + widget.GetData!["cover_photo"].toString()}");
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe0f7fa),
        body: Column(
          children: [
            // Top Header
            Container(
              color: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                    style: IconButton.styleFrom(backgroundColor: Colors.white12),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Events Details",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Make Content Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Slider (Now Scrollable)
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              // Shadow effect
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 220,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 0.85,
                                // Allows images to slightly peek from the sides
                                enableInfiniteScroll: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                              ),
                              items: imageList.map((imageUrl) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  // Rounded image corners
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          // Softer shadow
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Image.network(
                                      imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                          stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Icon(
                                              Icons.broken_image, size: 80,
                                              color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  imageList.length, (index) {
                                return Container(
                                  width: 10,
                                  height: 10,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentIndex == index ? Colors
                                        .blueAccent : Colors.grey[400],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      // Event Details
                      _buildInfoCard(Icons.business, "Organizer Name:",
                          widget.GetData!["company_name"].toString()),
                      _buildInfoCard(Icons.category, "Event Category:",
                          widget.GetData!["event_cat_name"].toString()),
                      _buildInfoCard(Icons.location_city, "City Name:",
                          widget.GetData!["city_name"].toString()),
                      _buildInfoCard(Icons.star, "Special Guest:",
                          widget.GetData!["special_attraction"].toString()),
                      _buildInfoCard(Icons.location_on, "Address 1:",
                          widget.GetData!["address_line_1"].toString()),
                      _buildInfoCard(Icons.location_on, "Address 2:",
                          widget.GetData!["address_line_2"].toString()),
                      _buildInfoCard(Icons.pin_drop, "Post Code:",
                          widget.GetData!["postcode"].toString()),
                      _buildInfoCard(Icons.map, "Latitude:",
                          widget.GetData!["latitude"].toString()),
                      _buildInfoCard(Icons.map, "Longitude:",
                          widget.GetData!["longtitude"].toString()),
                      _buildInfoCard(Icons.verified, "Is Approved:",
                          widget.GetData!["is_aprove"].toString()),
                      _buildInfoCard(Icons.calendar_today, "Start Date:",
                          widget.GetData!["event_start_date"].toString()),
                      _buildInfoCard(Icons.access_time, "Start Time:",
                          widget.GetData!["event_start_time"].toString()),
                      _buildInfoCard(Icons.event, "End Date:",
                          widget.GetData!["event_end_date"].toString()),
                      _buildInfoCard(Icons.watch_later, "End Time:",
                          widget.GetData!["event_end_time"].toString()),

                      // Event Tickets Section
                      SizedBox(height: 20),SizedBox(height: 20),

// Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              print("object getdata = ${widget.GetData}");
                              var eid = widget.GetData!["event_cat_id"];
                              print("eid = ${eid}");
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditEvents(
                                    GetData: widget.GetData,
                                    imgurl:  widget.GetData.toString(),
                                  ),
                                ),
                              );
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //   content: Text("Edit button pressed"),
                              // ));
                            },
                            icon: Icon(Icons.edit, color: Colors.white),
                            label: Text("Edit",style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Show the confirmation dialog
                              bool? confirmed = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 5),
                                        Text("Delete Event"),
                                      ],
                                    ),
                                    content: Text("Are you sure you want to delete this event and its tickets?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmed == true) {
                                var eventId=widget.GetData!["event_id"];
                                // final String eventId = widget.eventId; // Ensure this is available in your widget
                                Uri url = Uri.parse(UrlResourece.DELETEEVENTS); // Replace with your actual API URL

                                // Properly formatted body parameters
                                var parms = {
                                  "event_id": eventId,
                                };

                                try {
                                  var response = await http.post(url, body: parms);

                                  print("Raw response: ${response.body}");

                                  if (response.statusCode == 200) {
                                    var json = jsonDecode(response.body);
                                    if (json["status"] == "true") {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(json["messages"] ?? "Deleted successfully")),
                                      );
                                      // Navigate to OrganizerHome or relevant screen
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => OrganizerHome()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Failed to delete event: ${json["messages"]}")),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Failed to connect to the server")),
                                    );
                                  }
                                } catch (e) {
                                  print("Error: $e");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("An error occurred while deleting the event.")),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Row Layout
  Widget buildDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 4, // Adds depth to each item
      margin: EdgeInsets.symmetric(vertical: 6), // Space between cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        // Adds an icon for visual appeal
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
        subtitle: Text(
          value.isNotEmpty ? value : "Not Available",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
    );
  }
}
