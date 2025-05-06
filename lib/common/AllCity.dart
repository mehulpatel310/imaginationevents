import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:imaginationevents/common/AllState.dart';
import 'package:imaginationevents/common/StateEvents.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class AllCity extends StatefulWidget {
  final dynamic GetData;
  const AllCity({super.key, this.GetData});

  @override
  State<AllCity> createState() => _AllCityState();
}

class _AllCityState extends State<AllCity> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = '';
  Future<List<dynamic>?>? alldata;

  var img = UrlResourece.STATEIMG;
  List<dynamic>? _allEvents; // All events from API
  List<dynamic>? _filteredEvents; // Filtered based on search input
  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlResourece.ALLCITY);

    try {
      var response = await http.post(
        url,
        body: {'state_id': widget.GetData.toString()}, // assuming widget.GetData is correct
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var body = response.body.toString();
        print("body = ${body}");
        // var json = jsonDecode(body);
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

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
    setState(() {
      alldata = getdata();
      _searchController.addListener(() {
        filterEvents(_searchController.text);
      });
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _searchText = val.recognizedWords;
            _searchController.text = _searchText;
            filterEvents(_searchText);
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void filterEvents(String query) {
    final filtered = _allEvents?.where((event) {
      final category = event["city_name"].toString().toLowerCase();
      return category.contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredEvents = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        "No City Found",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.90, // ✅ Ensures proper spacing
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _filteredEvents!.length,
                    itemBuilder: (context, index) {
                      var state = _filteredEvents![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StateEvents(
                                GetData: state["city_id"].toString(),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Slightly more rounded
                            side: const BorderSide(color: Colors.black, width: 2.5), // Light border
                          ),
                          elevation: 6, // Slightly more elevation
                          shadowColor: Colors.black.withOpacity(0.1), // Softer shadow
                          child: Column(
                            children: [
                              Container(
                                width: 170,
                                height: 150,
                                padding: const EdgeInsets.all(4), // Slightly more padding
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  color: Colors.grey.shade50, // Light background for image area
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12), // Rounded image corners
                                  child: Image.network(
                                    img + state["state_image"].toString(),
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  state["city_name"].toString(),
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AllState())
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
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                "City List",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search State...",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color:
                    _isListening ? Colors.redAccent : Colors.grey,
                  ),
                  onPressed: _listen,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),

        ),
      ],
    );
  }

}
