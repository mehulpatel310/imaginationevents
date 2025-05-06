import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginationevents/Organizer/OrganizerHome.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  late Future<List<dynamic>?> alldata;
  Future<List<dynamic>?> getPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var orgId = prefs.getString("orgid") ?? "";

    if (orgId.isEmpty) {
      debugPrint("Organizer ID is empty.");
      return [];
    }

    var params = {
      "org_id": orgId,
    };

    Uri url = Uri.parse(UrlResourece.GETPAYMENTS); // your payments API URL
    debugPrint("Calling GETPAYMENTS API: $url with org_id = $orgId");

    try {
      var response = await http.post(url, body: params);
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200) {
        try {
          var json = jsonDecode(response.body);
          if (json['status'] == "true") {
            return json['data'];
          } else {
            debugPrint("API returned false status");
            return [];
          }
        } catch (e) {
          debugPrint("JSON Decode Error: $e");
          return [];
        }
      } else {
        debugPrint("Server Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("HTTP Error: $e");
      return [];
    }
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      alldata = getPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      color: Colors.deepPurple,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop(
                                MaterialPageRoute(builder: (context) => OrganizerHome()),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Payments",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: FutureBuilder(
                            future: alldata,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text("Error: ${snapshot.error}"));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text("No payments found."));
                              }

                              List payments = snapshot.data!;

                              return Column(
                                children: List.generate(payments.length, (index) {
                                  var payment = payments[index];

                                  return Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(16),
                                      title: Text(
                                        payment['event_title'] ?? "Event",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          Text("Check No: ${payment['check_no'] ?? 'N/A'}"),
                                          Text("Amount: ₹${payment['amount'] ?? '0'}"),
                                          Text("Commission: ₹${payment['comision_amount'] ?? '0'}"),
                                          Text("Date: ${payment['payment_datetime'] ?? 'N/A'}"),
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}