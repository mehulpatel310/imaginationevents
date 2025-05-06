import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imaginationevents/auth/Login.dart';
import 'package:http/http.dart' as http;
import 'package:imaginationevents/resources/UrlResource.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController number = TextEditingController();
  // TextEditingController gender = TextEditingController();
  File? photo1 = null;

  var gender = "male";

  var formkey = GlobalKey<FormState>();
  var img = UrlResourece.USERIMG;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
        return Stack(
        children: [
        Positioned(
        top: 20,
        child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,

        child: Image.asset("assets/img/admin_logo.png"),

        decoration: BoxDecoration(
        // color: Color(0xfff8bbd0),
        // image: DecorationImage(
        //     image: AssetImage("assets/image/admin_logo.png"),
        //     // fit: BoxFit.fill,
        //     alignment: Alignment.topCenter
        // ),
        ),
        ),
        ),
        Positioned(
        top: 205,
        child: ConstrainedBox(
        constraints: BoxConstraints(
        maxHeight: constraints.maxHeight - 160,
        ),
        child: SingleChildScrollView(
          child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          
          // color: Colors.blueAccent,
          decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(25)
          ),
          child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
          key: formkey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Center(child: Text(
          "Create Your Account",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 26),
          ),),
          Text("Name :",style: TextStyle(color: Colors.white),),
          TextFormField(
          validator:(val){
          if (val == null || val.isEmpty) {
          return "Please enter Name";
          }
          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) {
          return "Name should contain only letters";
          }
          return null;
          },
          
          decoration: InputDecoration(
          hintText: 'Enter Name',
          filled: true,
          // fillColor: Colors.amberAccent,
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(24),
          ),
          errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(24),
          ),
          focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(24),
          ),
          // labelText: 'Enter Name',
          prefixIcon: Icon(Icons.person),
          
          
          labelStyle: TextStyle(
          
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          ),
          ),
          controller: name,
          keyboardType: TextInputType.text,
          
          ),
          SizedBox(height: 10,),
          Text("Email :",style: TextStyle(color: Colors.white),),
          TextFormField(
          validator: (val) {
          if (val == null || val.isEmpty) {
          return "Please enter Email";
          }
          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(val)) {
          return "Enter a valid Email";
          }
          return null;
          },
          decoration: InputDecoration(
          hintText: 'Enter Email',
          filled: true,
          // fillColor: Colors.amberAccent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
          // labelText: 'Enter Email',
          prefixIcon: Icon(Icons.email),
          
          labelStyle: TextStyle(
          
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          ),
          ),
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          
          ),
          SizedBox(height: 10,),
          Text("Password :",style: TextStyle(color: Colors.white),),
          TextFormField(
          keyboardType: TextInputType.text,
          validator: (val) {
          if (val == null || val.isEmpty) {
          return "Please enter password";
          }
          if (!RegExp(r'^\d{8}$').hasMatch(val)) {
          return "Password must be at least 8 characters long";
          }
          return null;
          },
            obscureText: true,
          decoration: InputDecoration(
          hintText: 'Enter Password',
          filled: true,
          // fillColor: Colors.amberAccent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
          // labelText: 'Enter Password',
          prefixIcon: Icon(Icons.key),
          
          labelStyle: TextStyle(
          
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          ),
          ),
          controller: password,
          ),
          SizedBox(height: 10,),
          Text("Mobile Number :",style: TextStyle(color: Colors.white),),
          TextFormField(
          keyboardType: TextInputType.number,
          validator: (val)
          {
          if (val == null || val.isEmpty) {
          return "Please enter mobile";
          }
          if (!RegExp(r'^[0-9]{10,15}$').hasMatch(val)) {
          return "Enter a valid phone number";
          }
          return null;
          },
          decoration: InputDecoration(
          hintText: 'Enter Number',
          filled: true,
          // fillColor: Colors.amberAccent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
          // labelText: 'Enter Number',
          prefixIcon: Icon(Icons.contact_page),
          
          labelStyle: TextStyle(
          
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          ),
          ),
          controller: number,
          ),
          SizedBox(height: 10,),
            // Text(
            //   "User Image:",
            //   style: TextStyle(fontSize: 18),
            // ),

            // SizedBox(height: 10),

            Text("User Image :", style: TextStyle(color: Colors.white)),

            TextFormField(
              readOnly: true,
              // controller: photo1,
              onTap: () async {

                final ImagePicker _picker = ImagePicker();
                XFile? photo =
                await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  photo1 = File(photo!.path);
                });
              },
              decoration: InputDecoration(
                hintText: 'Choose Photo (jpg, jpeg)',
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                prefixIcon: Icon(Icons.image),
                labelStyle: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "Please select a photo";
              //   }
              //   return null;
              // },
            ),

            SizedBox(height: 5),

            if (photo1 != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  photo1!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
          Text("Gender :" ,style: TextStyle(color: Colors.white),),
            Row(
              children: [
                Text("Male",style: TextStyle(color: Colors.white),),
                Radio(value: "male", groupValue: gender, onChanged: (val){
                  setState(() {
                    gender = val!;
                  });
                }),
                Text("Female",style: TextStyle(color: Colors.white),),
                Radio(value: "female", groupValue: gender, onChanged: (val){
                  setState(() {
                    gender = val!;
                  });
                })
              ],
            ),

          SizedBox(
          height: 10,
          ),
            InkWell(
              onTap: () async {
                if (formkey.currentState!.validate()) {
                  var nm = name.text.toString();
                  var em = _email.text.toString();
                  var mo = number.text.toString();
                  var pass = password.text.toString();
                  var gn = gender.toString();

                  Uri url = Uri.parse(UrlResourece.REGISTER);
                  var request = http.MultipartRequest("POST", url);
                  request.fields['name'] = nm;
                  request.fields['email'] = em;
                  request.fields['mobileno'] = mo;
                  request.fields['password'] = pass;
                  request.fields['gender'] =gn;

                  print("Image: ${photo1!.path}");

                  var stream = http.ByteStream(photo1!.openRead());
                  var length = await photo1!.length();

                  var multipartFile = http.MultipartFile(
                    'user_img',
                    stream,
                    length,
                    filename: photo1!.path.split("/").last,
                  );

                  request.files.add(multipartFile);

                  var response = await request.send();

                  var responseBody = await http.Response.fromStream(response);
                  print("Response Code: ${response.statusCode}");
                  print("Response Body: ${responseBody.body}");

                  if (response.statusCode == 200) {

                    if (responseBody.body.trim() == "yes") {
                      print("Data inserted successfully");
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    } else {
                      print("Data not inserted");
                    }
                  } else {
                    print("Error: ${response.statusCode}");
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                decoration: BoxDecoration(
                  color: Color(0xfff8bbd0),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          SizedBox(
          height: 10,
          ),
          Center(
          child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          Text("Already have an account?",style: TextStyle(color: Colors.white),),
          InkWell(
          onTap: () {
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> Login())
          );
          },
          child: Text(
          "Login",
          style: TextStyle(color: Colors.white),
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
        ),
        )
        ),
        ],

        );
        }
        ),
      ),
    );
  }
}
