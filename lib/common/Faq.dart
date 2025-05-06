import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/common/UsrAccount.dart';
import 'package:imaginationevents/resources/UrlResource.dart';

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
          colors: [Colors.blueAccent, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  late Future<List<dynamic>?> alldata;

  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlResourece.ALLFAQ);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return jsonData["data"];
      } else {
        debugPrint("API Error: \${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching data: \$e");
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
      backgroundColor: Color(0xffe0f7fa),
      body: SafeArea(
        child: Column(

          children: [
            HeaderWidget(title: "FAQ Lists", onBack: () => Navigator.of(context).pop(MaterialPageRoute(builder: (context) => UsrAccount()))),
            SizedBox(height: 50,),
            Expanded(
              child: FutureBuilder<List<dynamic>?> (
                future: alldata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(

                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var faq = snapshot.data![index];
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          elevation: 4,

                          child: ExpansionTile(
                            title: Text(
                              faq["questions"],
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  faq["answer"],
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No FAQs available", style: TextStyle(fontSize: 18)));
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
