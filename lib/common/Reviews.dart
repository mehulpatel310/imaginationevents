import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/common/UsrAccount.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const HeaderWidget({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  late Future<List<dynamic>?> allReviews;

  var img = UrlResourece.USERIMG;
  Future<List<dynamic>?> fetchReviews() async {
    // Future<List<dynamic>?> getdata() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var ui = prefs.getString("userid") ?? "";

      if (ui.isEmpty) {
        debugPrint("User ID is empty.");
        return [];
      }

      Uri url = Uri.parse(UrlResourece.ALLREVIEWS);
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
  void initState() {
    super.initState();
    allReviews = fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f7fc),
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              title: "Reviews",
              onBack: () => Navigator.of(context)
                  .pop(MaterialPageRoute(builder: (context) => UsrAccount())),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>?>(
                future: allReviews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var review = snapshot.data![index];
                        return ReviewCard(review: review);
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(
                          "No Reviews Available",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final dynamic review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    String userImgUrl = "";

    // Check if user_img is provided and format it correctly
    if (review["user_img"] != null && review["user_img"].isNotEmpty) {
      userImgUrl = review["user_img"].toString().startsWith("http")
          ? review["user_img"]
          : "${UrlResourece.USERIMG}/${review["user_img"]}";
    }

    double rating = 0;
    if (review["rating"] != null) {
      rating = double.tryParse(review["rating"].toString()) ?? 0;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                backgroundImage: userImgUrl.isNotEmpty ? NetworkImage(userImgUrl) : null,
                child: userImgUrl.isEmpty
                    ? Text(
                  review["user_name"].toString()[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⭐ Star Rating
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review["review_txt"],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.event, color: Colors.grey, size: 16),
                  const SizedBox(width: 5),
                  Text("Event: ${review["event_title"]}"),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey, size: 18),
                      const SizedBox(width: 5),
                      Text("Name: ${review["name"]}"),
                    ],
                  ),
                  // Optional approval status if needed later
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

