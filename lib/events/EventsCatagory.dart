import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:imaginationevents/events/SubCategory.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:http/http.dart' as http;

class EventsCatagory extends StatefulWidget {
  const EventsCatagory({super.key});

  @override
  State<EventsCatagory> createState() => _EventsCatagoryState();
}

class _EventsCatagoryState extends State<EventsCatagory> {
  // Future<List<dynamic>?>? alldata;
  //
  // var img = UrlResourece.CATIMG;
  //
  // Future<List<dynamic>?>? getdata() async {
  //   Uri url = Uri.parse(UrlResourece.EVENTSCAT);
  //
  //   print("uri = ${url}");
  //   var responce = await http.get(url);
  //   print("responce = ${responce.statusCode}");
  //
  //   if (responce.statusCode == 200) {
  //     var body = responce.body.toString();
  //     print("body = ${body}");
  //     var json = jsonDecode(body);
  //     // print("json = ${json["data"]}");
  //
  //     return json["data"];
  //   } else {
  //     print("Api Error!");
  //   }
  // }

  late Future<List<dynamic>?> alldata;
  var img = UrlResourece.CATIMG;
  // final TextEditingController _searchController = TextEditingController();

  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlResourece.EVENTSCAT);

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return jsonData["data"];
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
    alldata = getdata();
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
                        "No Products Found",
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
                      var product = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SubCategory(
                                GetData: product["event_cat_id"],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), // More rounded corners
                          ),
                          elevation: 6,
                          shadowColor: Colors.black.withOpacity(0.2), // Softer shadow
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), // Rounded top corners
                                child: Container(
                                  height: 150, // ✅ Increased height for better image visibility
                                  width: double.infinity, // ✅ Ensures full width usage
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blueGrey.shade100, Colors.white], // Subtle background effect
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Image.network(
                                    img + product["event_cat_image"].toString(),
                                    width: double.infinity,
                                    height: 150, // ✅ Matches container height for a balanced aspect ratio
                                    fit: BoxFit.contain, // ✅ Prevents cropping while maintaining proper scaling
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                child: Text(
                                  product["event_cat_name"].toString(),
                                  style: const TextStyle(
                                    fontSize: 18, // Slightly larger font for better readability
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [

              const SizedBox(width: 20),
              const Text(
                "Events Catagory List",
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
