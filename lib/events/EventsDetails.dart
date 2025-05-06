import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imaginationevents/common/BookingTickets.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Eventsdetails extends StatefulWidget {
  Map<String, dynamic>? GetData;
  String? imgurl;

  Eventsdetails({super.key, this.GetData, this.imgurl});

  @override
  State<Eventsdetails> createState() => _EventsdetailsState();
}

class _EventsdetailsState extends State<Eventsdetails> {
  // TextEditingController _searchController = TextEditingController();
  TextEditingController _reviewController = TextEditingController();
  int rating = 5;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    alldata = getdata();
  }

  Future<List<dynamic>?>? alldata;

  // var img = UrlResourece.TICKETS;

  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlResourece.TICKETS);

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
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      widget.imgurl! + widget.GetData!["cover_photo"].toString(),
      widget.imgurl! + widget.GetData!["photo_1"].toString(),
      widget.imgurl! + widget.GetData!["photo_2"].toString(),
      widget.imgurl! + widget.GetData!["photo_3"].toString(),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe0f7fa),
        body: Column(
          children: [
            // Top Header
            Container(
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Icon(Icons.broken_image,
                                              size: 80, color: Colors.grey),
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
                              children:
                                  List.generate(imageList.length, (index) {
                                return Container(
                                  width: 10,
                                  height: 10,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentIndex == index
                                        ? Colors.blueAccent
                                        : Colors.grey[400],
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
                      SizedBox(height: 20),
                      Text(
                        "Event Tickets:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      FutureBuilder(
                        future: alldata,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          }
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var ticket = snapshot.data![index];
                                return Card(
                                  color: Color(0xfffafafa),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "🎟 Ticket Name: ${ticket["ticket_name"].toString()}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 5),
                                        Text(
                                            "📃 Description: ${ticket["ticket_description"].toString()}",
                                            style: TextStyle(fontSize: 14)),
                                        SizedBox(height: 5),
                                        Text(
                                            "💰 Price: \$${ticket["ticket_price"].toString()}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green)),
                                        SizedBox(height: 5),
                                        Text(
                                            "🎟 Total Tickets: ${ticket["total_ticket"].toString()}",
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(child: Text("No Tickets Available"));
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Leave a Review:",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 10),
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rate this Event:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: List.generate(5, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          rating = index + 1;
                                          print("rating =${rating}");
                                        });
                                      },
                                      child: Icon(
                                        Icons.star,
                                        size: 30,
                                        color: index < rating
                                            ? Colors.blueAccent
                                            : Colors.grey[300],
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Your Review:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: TextFormField(
                                    controller: _reviewController,
                                    maxLines: 4,
                                    style: TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(12),
                                      border: InputBorder.none,
                                      hintText: "Write your review here...",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a review';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var uid =
                                          prefs.getString("userid").toString();
                                      var eid = widget.GetData!["event_id"]
                                          .toString();

                                      var msg =
                                          _reviewController.text.toString();

                                      print("uid = ${uid}");
                                      print("eid = ${eid}");
                                      print("msg = ${msg}");
                                      print(
                                          "Rating: $rating, Review: \${_reviewController.text}");

                                      var params = {
                                        "event_id": eid.toString(),
                                        "user_id": uid,
                                        "review_txt": msg,
                                        "rating": rating.toString(),
                                        // "total_ticket": tl
                                      };

                                      print("Params: $params");
                                      Uri url =
                                          Uri.parse(UrlResourece.ADDREVIEWS);
                                      print("Request URL: $url");

                                      try {
                                        var response =
                                            await http.post(url, body: params);
                                        print(
                                            "Response Status Code: ${response.statusCode}");

                                        if (response.statusCode == 200) {
                                          var body = response.body.toString();
                                          print("Response Body: $body");
                                          var json = jsonDecode(body);
                                          print("Parsed JSON: $json");

                                          if (json["status"] == "true") {
                                            var msg =
                                                json["messages"].toString();
                                            print(msg);
                                            Fluttertoast.showToast(
                                              msg: "Success: $msg",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                            );
                                          } else {
                                            var msg =
                                                json["messages"].toString();
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
                                            msg:
                                                "Error: Server Issue (Code: ${response.statusCode})",
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
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: Text(
                                      "Submit Review",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Book Tickets Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: InkWell(
                onTap: () {
                  print("evid = ${widget.GetData!["event_id"]}");
                  var eid = widget.GetData!["event_id"];

                  print("eid = ${widget.GetData!["event_id"]}");

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BookingTickets(GetData: eid),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.orangeAccent,
                        Colors.orangeAccent
                      ], // Blue gradient effect
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Book Tickets",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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

  Widget _buildText(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      // Adds spacing between items
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 18, color: Colors.black),
          // Improved readability
          children: [
            TextSpan(
              text: label + " ",
              style: TextStyle(fontWeight: FontWeight.bold), // Bold for labels
            ),
            TextSpan(
              text: value.toString(),
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
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
