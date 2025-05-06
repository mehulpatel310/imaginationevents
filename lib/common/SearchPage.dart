import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedTitle;
  String? selectedCity;
  String? selectedOrganizer;
  String? selectedCategory;

  final List<String> titles = ["Conference", "Concert", "Workshop", "Festival"];
  final List<String> cities = ["New York", "Los Angeles", "Chicago", "Miami"];
  final List<String> organizers = ["Organizer A", "Organizer B", "Organizer C"];
  final List<String> categories = ["Music", "Business", "Tech", "Sports"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe0f7fa),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Blue Header Container
            Container(
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              width: double.infinity,
              child: Text(
                "Search Page",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20),

            // 🔹 Search Form Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Title"),
                    _buildDropdown(titles, selectedTitle, (value) {
                      setState(() {
                        selectedTitle = value;
                      });
                    }),

                    SizedBox(height: 15),

                    _buildLabel("City"),
                    _buildDropdown(cities, selectedCity, (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    }),

                    SizedBox(height: 15),

                    _buildLabel("Event Organizer"),
                    _buildDropdown(organizers, selectedOrganizer, (value) {
                      setState(() {
                        selectedOrganizer = value;
                      });
                    }),

                    SizedBox(height: 15),

                    _buildLabel("Event Category"),
                    _buildDropdown(categories, selectedCategory, (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }),

                    SizedBox(height: 30),

                    // 🔹 Search Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Perform Search Action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Search", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
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

  // 🔹 Dropdown Widget
  Widget _buildDropdown(List<String> items, String? selectedItem, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          isExpanded: true,
          hint: Text("Select", style: TextStyle(color: Colors.grey)),
          icon: Icon(Icons.arrow_drop_down),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  // 🔹 Label Text Widget
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }
}
