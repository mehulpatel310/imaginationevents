import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imaginationevents/Organizer/OrganizerHome.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgOtpScreen extends StatefulWidget {
  const OrgOtpScreen({super.key});

  @override
  State<OrgOtpScreen> createState() => _OrgOtpScreenState();
}

class _OrgOtpScreenState extends State<OrgOtpScreen> {
  var otp;
  TextEditingController txtotp = TextEditingController();

  getotp()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      otp = prefs.getString("otpdata").toString();
      print("otp = ${otp}");
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getotp().then((val){
      Fluttertoast.showToast(
          msg: otp,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/img/Animation.gif", height: 150),
                const SizedBox(height: 20),
                const Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please enter the 6-digit code sent to your email shortly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),

                /// OTP Field
                PinCodeTextField(
                  keyboardType: TextInputType.number,
                  controller: txtotp,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    inactiveColor: Colors.grey,
                    selectedColor: Colors.green,
                    activeColor: Colors.green,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  enableActiveFill: true,
                  appContext: context,
                ),
                const SizedBox(height: 30),

                /// Button
                ElevatedButton(
                  onPressed: () {


                    var otpdata = txtotp.text.toString();

                    print("otpdata = $otpdata");
                    print("otp = $otp");

                    if (otpdata== otp) {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrganizerHome(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a valid 6-digit OTP or Otp Not Match!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dummy Organizer home screen (replace with your actual screen)
class OrganizerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Organizer Home Screen")),
    );
  }
}
