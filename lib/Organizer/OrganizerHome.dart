import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/Organizer/AddEvents.dart';
import 'package:imaginationevents/Organizer/AddTickets.dart';
import 'package:imaginationevents/Organizer/Bookings.dart';
import 'package:imaginationevents/Organizer/ChangeOrgPassword.dart';
import 'package:imaginationevents/Organizer/OrgEventsDetails.dart';
import 'package:imaginationevents/Organizer/OrgFaq.dart';
import 'package:imaginationevents/Organizer/OrgOtpScreen.dart';
import 'package:imaginationevents/Organizer/OrgProfile.dart';
import 'package:imaginationevents/Organizer/OrgSupport.dart';
import 'package:imaginationevents/Organizer/OrgTickets.dart';
import 'package:imaginationevents/Organizer/Payments.dart';
import 'package:imaginationevents/Organizer/PrivancyPolicy.dart';
import 'package:imaginationevents/Organizer/ScanTickets.dart';
import 'package:imaginationevents/common/Faq.dart';
import 'package:imaginationevents/common/OrganizerUser.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizerHome extends StatefulWidget {
  const OrganizerHome({super.key});

  @override
  State<OrganizerHome> createState() => _OrganizerHomeState();
}

class _OrganizerHomeState extends State<OrganizerHome> {
  Future<List<dynamic>?>? alldata;
  var img = UrlResourece.EVENTS;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<dynamic>?> getdata() async {
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

    Uri url = Uri.parse(UrlResourece.ALLORGEVENTS);
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

  @override
  void initState() {
    super.initState();
    alldata = getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            color: Colors.deepPurple.shade900,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Menu",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      _buildDrawerItem(
                          Icons.home,
                          "My Events",
                          () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => OrganizerHome()));
                      }),
                      _buildDrawerItem(
                          Icons.event,
                          "Add Events",
                              () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => AddEvents()));
                          }),
                      _buildDrawerItem(
                          Icons.confirmation_num,
                          "Add Tickets",
                          () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => AddTickets()));
                          }),
                      _buildDrawerItem(
                          Icons.confirmation_num,
                          "My Tickets",
                              () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => OrgTickets()));
                          }),
                      _buildDrawerItem(
                          Icons.book_online,
                          "Bookings",
                          () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Bookings()));
                          }),
                      _buildDrawerItem(
                          Icons.document_scanner,
                          "Scan Tickets",
                          () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ScanTickets()));
                          }),
                      _buildDrawerItem(
                          Icons.payments,
                          "Payments",
                              () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Payments()));
                          }),
                      _buildDrawerItem(
                          Icons.person,
                          "My Profile",
                              () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => OrgProfile()));
                          }),
                      _buildDrawerItem(
                          Icons.lock,
                          "Change Password",
                              () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => ChangeOrgPassword()));
                          }),
                      _buildDrawerItem(Icons.help_outline, "FAQ", () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => OrgFaq()));
                      }),
                      _buildDrawerItem(
                          Icons.policy,
                          "Privacy Policy",
                              () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => PrivancyPolicy()));
                          }),
                      _buildDrawerItem(
                          Icons.support,
                          "Support",
                              () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Orgsupport()));
                          }),
                      // _buildDrawerItem(
                      //     Icons.support,
                      //     "OTP",
                      //         () {
                      //       Navigator.of(context).pop();
                      //       Navigator.push(context,
                      //           MaterialPageRoute(builder: (_) => OrgOtpScreen()));
                      //     }),
                      Divider(color: Colors.white60),
                      _buildDrawerItem(Icons.logout, "Logout", () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OrganizerUser()));
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: Icon(Icons.menu, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Imagination Events",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>?>(
                future: alldata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Events Found",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var event = snapshot.data![index];
                        return EventCard(event: event);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      onTap: onTap,
    );
  }
}

class EventCard extends StatefulWidget {
  final dynamic event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrgEventsDetails(
              GetData: widget.event,
              imgurl:  widget.event.toString(),
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        shadowColor: Colors.deepPurple.withOpacity(0.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.purple.shade100, Colors.deepPurple.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event["event_title"].toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade900,
                ),
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 250,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Image.network(
                        UrlResourece.EVENTS + widget.event["cover_photo"].toString(),
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        UrlResourece.EVENTS + widget.event["photo_1"].toString(),
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        UrlResourece.EVENTS + widget.event["photo_2"].toString(),
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        UrlResourece.EVENTS + widget.event["photo_3"].toString(),
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
