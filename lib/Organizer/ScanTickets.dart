import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imaginationevents/Organizer/OrganizerHome.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class ScanTickets extends StatefulWidget {
  const ScanTickets({super.key});

  @override
  State<ScanTickets> createState() => _ScanTicketsState();
}

class _ScanTicketsState extends State<ScanTickets> {
  String scanResult = "Scanning...";
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    cameraController.start();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        MaterialPageRoute(builder: (context) => OrganizerHome()),
                      );
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                    style: IconButton.styleFrom(backgroundColor: Colors.white24),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Scan Tickets",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MobileScanner(
                controller: cameraController,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    setState(() {
                      scanResult = barcode.rawValue ?? "Unknown";
                    });
                    print("Scanned QR Code: $scanResult");
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    scanResult,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      print("OK button pressed with scanned ID: $scanResult");

                      var url = Uri.parse(UrlResourece.ENTERY_TICKETS);

                      try {
                        var response = await http.post(
                          url,
                          body: {
                            'booked_ticket_id': scanResult,
                          },
                        );

                        if (response.statusCode == 200) {
                          var data = json.decode(response.body);

                          String message = data['messages'] ?? 'Unknown response';
                          bool isSuccess = data['status'] == "true";

                          // Show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: isSuccess ? Colors.green : Colors.red,
                            ),
                          );

                          if (isSuccess) {
                            // Optional: do something on success, like pop or clear scanner
                            // Navigator.pop(context);
                          }
                        } else {
                          print("Server error: ${response.statusCode}");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Server error: ${response.statusCode}"),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      } catch (e) {
                        print("Error occurred: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Something went wrong!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text("OK"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
