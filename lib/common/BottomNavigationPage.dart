import 'package:flutter/material.dart';
import 'package:imaginationevents/common/Home.dart';
import 'package:imaginationevents/common/SearchPage.dart';
import 'package:imaginationevents/common/UsrAccount.dart';
import 'package:imaginationevents/events/Events.dart';
import 'package:imaginationevents/events/EventsCatagory.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Events(),
    EventsCatagory(),
    UsrAccount(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   showSelectedLabels: true,
      //   showUnselectedLabels: true,
      //   selectedItemColor: Colors.blueAccent,
      //   unselectedItemColor: Colors.black,
      //   currentIndex: _selectedIndex,
      //   onTap: (value) {
      //     // Respond to item press.
      //     setState(() {
      //       _selectedIndex = value;
      //     });
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //
      //         icon: Icon(Icons.home),
      //         label: "Home"
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.event),
      //         label: "Event"
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.search),
      //         label: "Search"
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.airplane_ticket),
      //         label: "My Ticket"
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.person),
      //         label: "My Account"
      //     )
      //   ],
      // ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.home),
            //     label: 'Home',
            //     backgroundColor: Colors.green
            // ),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.search),
            //     label: 'Search',
            //     backgroundColor: Colors.yellow
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person),
            //   label: 'Profile',
            //   backgroundColor: Colors.blue,
            // ),
        BottomNavigationBarItem(

                icon: Icon(Icons.home),
                label: "Home"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: "Event"
            ),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.search),
            //     label: "Search"
            // ),
            BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: "Category"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "My Account"
            )
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5
      ),
      // body: Column(
      //   children: [
      //     // Home(),
      //     // Events(),
      //     // Home(),
      //     // Events(),
      //     // Events(),
      //
      //     SingleChildScrollView(
      //       child: Text("home"),
      //     ),
      //     SingleChildScrollView(
      //       child: Text("event"),
      //     ),
      //     SingleChildScrollView(
      //       child: Text("search"),
      //     ),
      //     SingleChildScrollView(
      //       child: Text("home"),
      //     ),
      //     SingleChildScrollView(
      //       child: Text("home"),
      //     )
      //
      //   ],
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
