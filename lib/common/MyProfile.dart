import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  late Future<List<dynamic>?> alldata;
  var img = UrlResourece.USERIMG;
  @override
  void initState() {
    super.initState();
    alldata = getdata();
  }

  Future<List<dynamic>?> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ui = prefs.getString("userid") ?? "";

    if (ui.isEmpty) {
      debugPrint("User ID is empty.");
      return [];
    }

    Uri url = Uri.parse(UrlResourece.USER);
    try {
      var response = await http.post(url, body: {"user_id": ui});
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return jsonData["data"];
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              // padding: const EdgeInsets.all(20),
              // decoration: const BoxDecoration(
              //   color: Colors.blueAccent,
              //
              //   // borderRadius: BorderRadius.only(
              //   //   bottomLeft: Radius.circular(30),
              //   //   bottomRight: Radius.circular(30),
              //   // ),
              // ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black,size: 30,),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 20),
            //
            // const

            Expanded(
              child: FutureBuilder<List<dynamic>?>(
                future: alldata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Profile Data Found"));
                  } else {
                    var userData = snapshot.data![0]; // Assuming first item contains user details

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        children: [
                          SizedBox(height: 20),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            child: ClipOval(
                              child: userData["user_img"] != null
                                  ? Image.network(
                                img + userData["user_img"].toString(),
                                width: 100, // Ensure it covers the circular area
                                height: 100,
                                fit: BoxFit.cover, // Covers the circular shape properly
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              )
                                  : Icon(Icons.person, size: 50, color: Colors.grey),
                            ),
                          ),

                          SizedBox(height: 20,),
                          profileDetailRow("Name :", userData["name"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("Email :", userData["email"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("Mobile No :", userData["mobile_no"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("Gender :", userData["gender"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("Active Status :", userData["is_verify"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("Registered On :", userData["regi_datetime"].toString()),
                          SizedBox(height: 20,),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     child: ListView(
            //       children: [
            //         profileDetailRow("Name", userData["name"]),
            //         profileDetailRow("Email", userData["email"]),
            //         profileDetailRow("Verified", userData["is_verify"] ? "Yes" : "No"),
            //         profileDetailRow("Mobile No", userData["mobile_no"]),
            //         profileDetailRow("Gender", userData["gender"]),
            //         profileDetailRow("Registered On", userData["regi_datetime"]),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget profileDetailRow(String title, String value) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
