import 'package:flutter/material.dart';
import 'package:imaginationevents/common/ChangePassword.dart';
import 'package:imaginationevents/common/Faq.dart';
import 'package:imaginationevents/common/MyBookingList.dart';
import 'package:imaginationevents/common/MyProfile.dart';
import 'package:imaginationevents/common/OrganizerUser.dart';
import 'package:imaginationevents/common/Reviews.dart';
import 'package:imaginationevents/common/ThankYou.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsrAccount extends StatefulWidget {
  const UsrAccount({super.key});

  @override
  State<UsrAccount> createState() => _UsrAccountState();
}

class _UsrAccountState extends State<UsrAccount> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe0f7fa), // Light background color
        body: Column(
          children: [
            // 🔹 HEADER
            Container(
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text(
                    "User Account",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 ACCOUNT OPTIONS
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: ListView(
                  children: [
                    _buildAccountOption(
                      icon: Icons.book,
                      title: "My Booking",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyBookingList(),
                          ),
                        );
                      },
                    ),
                    _buildAccountOption(
                      icon: Icons.rate_review,
                      title: "Reviews",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Reviews(),
                          ),
                        );
                      },
                    ),
                    _buildAccountOption(
                      icon: Icons.help_outline,
                      title: "FAQ",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Faq(),
                          ),
                        );
                      },
                    ),
                    _buildAccountOption(
                      icon: Icons.person,
                      title: "My Profile",
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Myprofile(),
                            ),
                        );
                      },
                    ),
                    _buildAccountOption(
                      icon: Icons.lock,
                      title: "Change Password",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChangePassword(),
                          ),
                        );
                      },
                    ),
                    _buildAccountOption(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        _showLogoutDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async{
                // Perform Logout
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrganizerUser(),
                  ),
                );
                // Navigator.
                // Navigator.pop(context);
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
