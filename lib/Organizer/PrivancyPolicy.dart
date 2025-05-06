import 'package:flutter/material.dart';

class PrivancyPolicy extends StatefulWidget {
  const PrivancyPolicy({super.key});

  @override
  State<PrivancyPolicy> createState() => _PrivancyPolicyState();
}

class _PrivancyPolicyState extends State<PrivancyPolicy> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    style: IconButton.styleFrom(backgroundColor: Colors.white24),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Privacy Matters",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(thickness: 2, color: Colors.deepPurpleAccent),
                          SizedBox(height: 10),
                          _buildPrivacySection(
                            "1. Introduction",
                            "Welcome to Imagination Events. We value your privacy and are committed to protecting your personal data.",
                          ),
                          _buildPrivacySection(
                            "2. Data Collection",
                            "We collect your name, email, and booking details to enhance your event experience.",
                          ),
                          _buildPrivacySection(
                            "3. Data Usage",
                            "Your data is used for processing bookings, sending event notifications, and improving our services.",
                          ),
                          _buildPrivacySection(
                            "4. Security",
                            "We implement industry-standard measures to protect your data from unauthorized access.",
                          ),
                          _buildPrivacySection(
                            "5. Contact Us",
                            "For any privacy-related inquiries, please contact us at support@imaginationevents.com",
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Agree & Continue",
                                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

