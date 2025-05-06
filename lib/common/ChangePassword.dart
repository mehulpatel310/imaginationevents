import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imaginationevents/common/Home.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Blue Header
            Container(
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                    style: IconButton.styleFrom(backgroundColor: Colors.white24),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // 🔹 Password Change Form
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildPasswordField("Old Password", oldPasswordController, _obscureOldPassword, () {
                      setState(() {
                        _obscureOldPassword = !_obscureOldPassword;
                      });
                    }, (value) {
                      if (value!.isEmpty) {
                        return "Old password is required";
                      }
                      return null;
                    }),

                    SizedBox(height: 15),

                    buildPasswordField("New Password", newPasswordController, _obscureNewPassword, () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    }, (value) {
                      if (value!.isEmpty) {
                        return "New password is required";
                      } else if (value.length < 6) {
                        return "New password must be at least 6 characters";
                      }
                      return null;
                    }),

                    SizedBox(height: 15),

                    buildPasswordField("Confirm Password", confirmPasswordController, _obscureConfirmPassword, () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    }, (value) {
                      if (value!.isEmpty) {
                        return "Confirm password is required";
                      } else if (value != newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    }),

                    SizedBox(height: 30),

                    // 🔹 Gradient Change Password Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // *Fixed Submission Issue*
                          if (oldPasswordController.text.isEmpty ||
                              newPasswordController.text.isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "All fields are required!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                            return; // Stop execution if any field is empty
                          }

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var userId = prefs.getString("userid") ?? "";

                          var params = {
                            "oldpassword": oldPasswordController.text,
                            "newpassword": newPasswordController.text,
                            "conformpassword": confirmPasswordController.text,
                            "loginid": userId,
                          };

                          try {
                            Uri url = Uri.parse(UrlResourece.CHANGEUSERPASS);
                            var response = await http.post(url, body: params);

                            print("Response: ${response.body}");

                            if (response.statusCode == 200) {
                              var responseBody = response.body.trim();

                              if (responseBody.startsWith("{") && responseBody.endsWith("}")) {
                                var json = jsonDecode(responseBody);

                                Fluttertoast.showToast(
                                  msg: json["messages"] ?? "Unknown Response",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                );

                                // *Navigate only if API response is successful*
                                if (json["messages"] == "Password changed successfully") {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Home()));
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Invalid API Response",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Server Error: ${response.statusCode}",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                              );
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: "Error: $e",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.blueAccent,
                          shadowColor: Colors.blue.withOpacity(0.3),
                          elevation: 5,
                        ),
                        child: Text(
                          "Change Password",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
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

  // 🔹 Password Field Widget with Validation
  Widget buildPasswordField(
      String label,
      TextEditingController controller,
      bool obscureText,
      VoidCallback toggleVisibility,
      String? Function(String?) validator) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.blueAccent),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
