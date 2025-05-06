import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/events/EventsDetails.dart';
import 'dart:convert';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = '';

  Future<List<dynamic>?>? alldata;

  var img = UrlResourece.EVENTS;

  List<dynamic>? _allEvents; // All events from API
  List<dynamic>? _filteredEvents; // Filtered based on search input

  Future<List<dynamic>?>? getdata() async {
    Uri url = Uri.parse(UrlResourece.USEREVENTS);

    print("uri = ${url}");
    var responce = await http.get(url);
    print("responce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("body = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");
      _allEvents = json["data"];
      _filteredEvents = _allEvents;
      return _filteredEvents;
    } else {
      print("Api Error!");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
    setState(() {
      alldata = getdata();
    });
   TextEditingController(text: _searchText).addListener(() {
      filterEvents( TextEditingController(text: _searchText).text);
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
        _speech.listen(
          onResult: (val) {
            setState(() {
              _searchText = val.recognizedWords;
              _searchController.text = _searchText;
              filterEvents(_searchText);
            });
          },
        );


      } else {
        print('Speech recognition not available');
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }


  void filterEvents(String query) {
    final filtered = _allEvents?.where((event) {
      final category = event["event_title"].toString().toLowerCase();
      return category.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredEvents = filtered;
    });
  }


  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                color: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [

                        SizedBox(width: 10),
                        Text(
                          "Events Lists",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _searchController,

                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                                onPressed: _listen,
                              ),

                              hintText: "Search events...",
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            onChanged: (value) => _searchText = value,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Add filter functionality here
                            },
                            icon: Icon(Icons.filter_list, color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 150,
                bottom: 1, // Fixed incorrect "01"
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight - 160,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xffe0f7fa),
                      padding: EdgeInsets.only(bottom: 10),

                      child: FutureBuilder(
                        future: alldata,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error loading data"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text("No Data"));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true, // Ensures it only takes the space needed
                              physics: NeverScrollableScrollPhysics(), // Prevents conflict with SingleChildScrollView
                              itemCount: _filteredEvents!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
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
                                  child: SizedBox(
                                    height: 300, // Fixed height for uniformity
                                    child: Card(
                                      elevation: 6, // Adds depth with a shadow effect
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15), // Smooth rounded edges
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [Colors.cyanAccent.shade100, Colors.blueAccent.shade100], // Smooth color blend
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          border: Border.all(color: Colors.white, width: 2), // Adds a subtle outline
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(10), // Proper spacing
                                              child: Text(
                                                _filteredEvents![index]["event_title"].toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                  letterSpacing: 1.2, // Adds slight spacing for better readability
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),

                                            // Image with an overlay for a more premium look
                                            Expanded(
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(15),
                                                      bottomRight: Radius.circular(15),
                                                    ),
                                                    child: Image.network(
                                                      img + _filteredEvents![index]["cover_photo"].toString(),
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    ),
                                                  ),

                                                  // Subtle Overlay for Better Readability
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(15),
                                                        bottomRight: Radius.circular(15),
                                                      ),
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                                                        begin: Alignment.bottomCenter,
                                                        end: Alignment.topCenter,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
