import 'package:flutter/material.dart';
import 'package:imaginationevents/Organizer/OrganizerHome.dart';
import 'package:imaginationevents/Organizer/OrganizerLogin.dart';
import 'package:imaginationevents/auth/Login.dart';
import 'package:imaginationevents/common/BottomNavigationPage.dart';
import 'package:imaginationevents/common/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OrganizerUser(),
    );
  }
}

checkuserlogin(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey("islogin")) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  } else {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }
}

checkorglogin(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey("isorglogin")) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OrganizerHome()));
  } else {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OrganizerLogin()));
  }
}

class OrganizerUser extends StatelessWidget {
  const OrganizerUser({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final Size screenSize = MediaQuery.of(context).size;
    final double buttonWidth = screenSize.width * 0.8;
    final double fontSize = screenSize.width * 0.06;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Title
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: Text(
                  "Welcome to Event Manager",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenSize.height * 0.05),
              // Organizer Login Button
              _buildButton(
                context,
                "Organizer Login",
                Icons.business,
                Colors.orange,
                buttonWidth,
                () {
                  checkorglogin(context);
                }
              ),
              SizedBox(height: screenSize.height * 0.03),
              // User Login Button
              _buildButton(
                context,
                "User Login",
                Icons.person,
                Colors.green,
                buttonWidth,
                () {
                  checkuserlogin(context);
                }
              ),
              const Spacer(),
            ],
          ),
          // Skip Button at the top-right
        ],
      ),
    );
  }

  // Responsive Button
  Widget _buildButton(BuildContext context, String text, IconData icon,
      Color color, double width, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: width,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: Icon(icon, color: Colors.white),
          label: Text(
            text,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
                color: Colors.white),
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}

// Placeholder pages for navigation
// class OrganizerLogin extends StatelessWidget {
//   const OrganizerLogin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Organizer Login")),
//       body: const Center(child: Text("Organizer Login Page")),
//     );
//   }
// }
//
// class UserLogin extends StatelessWidget {
//   const UserLogin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("User Login")),
//       body: const Center(child: Text("User Login Page")),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Home Page")),
//       body: const Center(child: Text("Welcome to Home Page")),
//     );
//   }
// }
