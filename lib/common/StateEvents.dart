import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imaginationevents/common/AllCity.dart';
import 'package:imaginationevents/common/AllState.dart';
import 'package:imaginationevents/events/EventsDetails.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:http/http.dart' as http;

class StateEvents extends StatefulWidget {
  final dynamic GetData;
  StateEvents({super.key, this.GetData});

  @override
  State<StateEvents> createState() => _StateEventsState();
}

class _StateEventsState extends State<StateEvents> {

  late Future<List<dynamic>?> alldata;
  var img = UrlResourece.EVENTS;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic>? _allEvents; // All events from API
  List<dynamic>? _filteredEvents; // Filtered based on search input
  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlResourece.STATEVISEEVENTS);

    try {
      var response = await http.post(
        url,
        body: {'city_id': widget.GetData}, // assuming widget.GetData is correct
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var body = response.body.toString();
        print("body = ${body}");
        var json = jsonDecode(body);
        if (jsonData["status"] == "true") {
          _allEvents = jsonData["data"];
          _filteredEvents = _allEvents;
          return _filteredEvents;
        } else {
          debugPrint("API returned: ${jsonData["messages"]}");
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
    super.initState();
    alldata = getdata(); // Now it works without an argument
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopSection(),
            Expanded(
              child: FutureBuilder(
                future: alldata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Events Found",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75, // ✅ Ensures proper spacing
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var subcategory = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Eventsdetails(
                                GetData: _filteredEvents![index],
                                imgurl: img,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          child: Column(
                            children: [
                              Container(
                                width: 170, // ✅ Ensures uniform image height
                                height: 150, // ✅ Ensures uniform image height
                                padding: const EdgeInsets.all(2),
                                child: Image.network(
                                  img + subcategory["cover_photo"].toString(),
                                  width: double.infinity,
                                  fit: BoxFit.contain, // ✅ No more cropping!
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 10),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  subcategory["event_title"].toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 8),
                              //   child: Text(
                              //     subcategory["state_name"].toString(),
                              //     style: const TextStyle(
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.black87,
                              //     ),
                              //     textAlign: TextAlign.center,
                              //     maxLines: 2,
                              //     overflow: TextOverflow.ellipsis,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTopSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
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
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                "State Vise Events",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
