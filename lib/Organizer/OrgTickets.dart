import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginationevents/Organizer/EditTickets.dart';
import 'package:imaginationevents/Organizer/OrganizerHome.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgTickets extends StatefulWidget {
  Map<String, dynamic>? GetData;
 OrgTickets({super.key});

  @override
  State<OrgTickets> createState() => _OrgTicketsState();
}

class _OrgTicketsState extends State<OrgTickets> {
  late Future<List<dynamic>?> alldata;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<dynamic>?> getTickets() async {
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

    Uri url = Uri.parse(UrlResourece.GETTICKETS);
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

  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      alldata = getTickets();
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop(
                                    MaterialPageRoute(builder: (context) => OrganizerHome())
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
                                    "Tickets",
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
                            // height:MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height,

                            // color: Colors.blueAccent,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(25)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: FutureBuilder(
                                future: alldata, // call your API function here
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text("Error: ${snapshot.error}"));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Center(child: Text("No tickets found."));
                                  }

                                  List tickets = snapshot.data!;

                                  return Column(
                                    children: List.generate(tickets.length, (index) {
                                      var ticket = tickets[index];

                                      return Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Event ID: ${ticket['event_title']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text("Ticket Name: ${ticket['ticket_name']}", style: TextStyle(fontSize: 15)),
                                              SizedBox(height: 5),
                                              Text("Description: ${ticket['ticket_description']}", style: TextStyle(fontSize: 15)),
                                              SizedBox(height: 5),
                                              Text("Price: ₹${ticket['ticket_price']}", style: TextStyle(fontSize: 15)),
                                              SizedBox(height: 5),
                                              Text("Total Tickets: ${ticket['total_ticket']}", style: TextStyle(fontSize: 15)),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      var ticket = tickets[index];
                                                      if (ticket == null) {
                                                        print("Ticket at index $index is null!");
                                                        return;
                                                      }

                                                      var tid = ticket["event_ticket_id"];
                                                      print("tid = $tid");

                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => EditTickets(
                                                            GetData: ticket,
                                                          ),
                                                        ),
                                                      );

                                                      print("Edit ticket ${ticket['ticket_name']}");
                                                    },
                                                    icon: Icon(Icons.edit, size: 18),
                                                    label: Text("Edit"),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.orange,
                                                      foregroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  ElevatedButton.icon(
                                                    onPressed: () async {
                                                      final ticketId = ticket['event_ticket_id']; // Replace with actual key
                                                      final ticketName = ticket['ticket_name']; // For logging

                                                      print("Deleting ticket $ticketName");

                                                      final url = Uri.parse(UrlResourece.ORGDELETETICKETS); // Replace with your API URL

                                                      try {
                                                        final response = await http.post(
                                                          url,
                                                          body: {
                                                            'ticket_id': ticketId.toString(),
                                                          },
                                                        );

                                                        if (response.statusCode == 200) {
                                                          final body = response.body;
                                                          print("Response: $body");

                                                          // Show a success message using SnackBar
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('Ticket deleted successfully!'),
                                                              backgroundColor: Colors.green,
                                                            ),
                                                          );

                                                          // Optionally, navigate back to refresh the current page if needed
                                                          Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => OrgTickets(), // Refresh current page
                                                            ),
                                                          );
                                                        } else {
                                                          print("Failed to delete ticket. Server error.");
                                                          // Optionally, you can show an error message if deletion fails
                                                        }
                                                      } catch (e) {
                                                        print("Error deleting ticket: $e");
                                                        // Optionally, show an error message for exception
                                                      }
                                                    },
                                                    icon: Icon(Icons.delete, size: 18),
                                                    label: Text("Delete"),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.red,
                                                      foregroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                },
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
