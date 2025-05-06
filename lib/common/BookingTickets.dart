import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:imaginationevents/common/ThankYou.dart';
import 'package:imaginationevents/resources/UrlResource.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingTickets extends StatefulWidget {
  var GetData;

  BookingTickets({super.key, this.GetData});

  @override
  State<BookingTickets> createState() => _BookingTicketsState();
}

class _BookingTicketsState extends State<BookingTickets> {
  // Define variables to store dropdown values
  int goldTicketValue = 1;
  int silverTicketValue = 1;
  int bronzeTicketValue = 1;
  Future<List<dynamic>?>? alldata;

  // var img = UrlResourece.TICKETS;

  Razorpay _razorpay = Razorpay();

  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlResourece.TICKETS);

    try {
      var response = await http.post(
        url,
        body: {
          'event_id': widget.GetData.toString()
        }, // Send the category ID properly
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print("jsonData = ${jsonData["data"]}");
        return jsonData["data"] ?? []; // Ensure it's always a list
      } else {
        debugPrint("API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return [];
    }
  }
  Map<String, int> selectedTickets = {};

  @override
  void initState() {
    super.initState();
    alldata = getdata();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }


  // late List<String> tid;
  // late List<String> totalTickets;
  // late List<String> amt;

  // late String tid;
  int availableTickets = 0;
  // late String amt;
  List<String> tid = [];
  List<String> amt = [];

  //
  // Future<void> _handlePaymentSuccess(PaymentSuccessResponse paymentresponse) async {
  //   // Do something when payment succeeds
  //
  //   // var add1 = addressline1.text.toString();
  //   // var add2 = addressline2.text.toString();
  //   // var pin = pincode.text.toString();
  //
  //
  //   // 200 ok
  //   //400 no found
  //   //500 sever
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var ui =  prefs.getString("userid").toString();
  //   var eid = widget.GetData.toString();
  //
  //   print("userid = ${ui}");
  //   print("eid = ${eid}");
  //   print("transaction_no = ${paymentresponse.paymentId.toString()}");
  //   print("amount = ${finalTotal}");
  //   print("event_ticket_id = ${tid.toString()}");
  //   print("totalTickets = ${availableTickets}");
  //   print("totalPrices = ${amt}");
  //   // print("discount = ${discountedTotal.toString()}");
  //   // print("amt = ${amt}");
  //   // print("deliverycharges = ${deliverycharges.toString()}");
  //   // print("tranid = ${paymentresponse.paymentId.toString()}");
  //
  //
  //
  //   var parms = {
  //     'user_id': ui,
  //     'event_id': eid,
  //     'transaction_no': paymentresponse.paymentId.toString(),
  //     'amount': finalTotal.toString(),
  //     // 'booking_date_time': bookingDateTime,
  //     'event_ticket_id[]': tid.join(','),
  //     'total_tickets[]': selectedTickets.toString(),
  //     'total_price[]': amt.join(','),
  //
  //   };
  //
  //   print("parms = ${parms}");
  //   Uri url = Uri.parse(UrlResourece.ADDBOOKING);
  //
  //   print("uri = ${url}");
  //   var responce = await http.post(url,body: parms);
  //   print("responce = ${responce.statusCode}");
  //
  //   if(responce.statusCode==200)
  //   {
  //     // var body = responce.body.toString();
  //     // print("body = ${body}");
  //     var json = jsonDecode(responce.body.toString());
  //     print("json = ${json}");
  //
  //     if(json["status"]=="true")
  //     {
  //       var msg = json["messages"].toString();
  //       print(msg);
  //       Fluttertoast.showToast(
  //           msg: "Payment Successful",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0
  //       );
  //       Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => ThankYou()),
  //       );
  //     }
  //     else
  //     {
  //       var msg = json["messages"].toString();
  //       print(msg);
  //     }
  //   }
  //   else
  //   {
  //     print("Api Error!");
  //   }
  // }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse paymentresponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ui = prefs.getString("userid").toString();
    var eid = widget.GetData.toString();

    // Ensure ticket data is collected properly
    List<String> ticketIds = [];
    List<String> ticketQuantities = [];
    List<String> ticketPrices = [];
    List<String> totalPrices = [];
    selectedTickets.forEach((ticketName, quantity) {
      if (quantity > 0) {
        var ticket = alldata!.then((list) => list?.firstWhere((t) => t["ticket_name"] == ticketName));

        ticket.then((t) {
          String ticketId = t["event_ticket_id"].toString();
          String price = t["ticket_price"].toString();

          // Convert price to integer and calculate total price
          int totalPrice = quantity * int.parse(price);

          ticketIds.add(ticketId);
          ticketQuantities.add(quantity.toString());
          ticketPrices.add(price);
          totalPrices.add(totalPrice.toString()); // Store calculated total price
        });
      }
    });

// Printing for debugging
    print("Ticket IDs: $ticketIds");
    print("Quantities: $ticketQuantities");
    print("Prices: $ticketPrices");
    print("Total Prices: $totalPrices");

    // Wait for all async operations to complete
    await Future.delayed(Duration(milliseconds: 100));

    print("etid = ${ticketIds.join(',')}");

    var params = {
      'user_id': ui,
      'event_id': eid,
      'transaction_no': paymentresponse.paymentId.toString(),
      'amount': finalTotal.toString(),
      'event_ticket_id': ticketIds.join(','),  // Ensure unique IDs
      'total_tickets': ticketQuantities.join(','), // Convert map to list
      'total_price': totalPrices.join(","), // Correct price values
    };

    print("params = ${params}");

    Uri url = Uri.parse(UrlResourece.ADDBOOKING);
    var response = await http.post(url, body: params);

    print("response = ${response.statusCode}");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      print("json = ${json}");

      if (json["status"] == "true") {
        Fluttertoast.showToast(
          msg: "Payment Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ThankYou()));
      } else {
        print("API Error: ${json["messages"]}");
      }
    } else {
      print("API Error!");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails

    print("PaymentFailure");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("Payment wallet Failure");

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }
  late double finalTotal;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe0f7fa),
        body: Column(
          children: [
            // Top Header
            Container(
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Book Tickets",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Make Content Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Slider (Now Scrollable)
                      SizedBox(height: 20),
                      Text(
                        "Event Tickets:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      FutureBuilder(
                        future: alldata,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          }
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                             finalTotal = calculateTotal(snapshot.data!);

                            return Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var ticket = snapshot.data![index];
                                    String ticketName = ticket["ticket_name"].toString();
                                     availableTickets = int.tryParse(ticket["total_ticket"].toString()) ?? 0;
                                    tid.add(ticket["event_ticket_id"].toString());
                                    amt.add(ticket["ticket_price"].toString());


                                    // Initialize selected value as 0 instead of 1
                                    selectedTickets[ticketName] ??= 0;
                                   // amt = ticket["ticket_price"].toString();
                                    return Card(
                                      color: Color(0xfffafafa),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "🎟 Ticket Name: $ticketName",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "💰 Price: \$${ticket["ticket_price"]}",
                                              style: TextStyle(fontSize: 14, color: Colors.green),
                                            ),
                                            Text(
                                              "🎟 Total Tickets: ${ticket["total_ticket"]}",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 5),

                                            // Ticket Dropdown with default value = 0
                                        ticketDropdown(
                                          ticketName,
                                          selectedTickets[ticketName]!,
                                          availableTickets,  // Now correctly an int
                                              (value) {
                                            setState(() {
                                              selectedTickets[ticketName] = value!;
                                              print("selectedTickets[ticketName] ${selectedTickets[ticketName]}");
                                            });
                                          },
                                        ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                SizedBox(height: 20),

                                // Display Final Total
                                Text(
                                  "Total Price: \$${finalTotal!.toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            );
                          } else {
                            return Center(child: Text("No Tickets Available"));
                          }
                        },
                      ),


                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Book Tickets Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: InkWell(
                onTap: () {



                  var options = {
                    'key': 'rzp_test_EKsJXH84MtJBG2',
                    'amount':finalTotal * 100,
                    'name': 'Acme Corp.',
                    'description': 'Fine T-Shirt',
                    'prefill': {
                      'contact': '8888888888',
                      'email': 'test@razorpay.com'
                    }
                  };

                  _razorpay.open(options);

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => ThankYou()),
                  // );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.orangeAccent,
                        Colors.orangeAccent
                      ], // Blue gradient effect
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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
  double calculateTotal(List<dynamic> ticketData) {
    double total = 0.0;

    for (var ticket in ticketData) {
      String ticketName = ticket["ticket_name"].toString();
      double price = double.tryParse(ticket["ticket_price"].toString()) ?? 0.0;
      int quantity = selectedTickets[ticketName] ?? 0;

      if (quantity > 0) {
        total += price * quantity;
      }
    }

    return total;
  }

  Widget ticketDropdown(
      String title, int selectedValue, int totalTickets, Function(int?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        DropdownButton<int>(
          value: selectedValue,
          onChanged: onChanged,
          dropdownColor: Colors.white,
          items: List.generate(totalTickets + 1, (index) => index) // Start from 0
              .map((num) => DropdownMenuItem(
            value: num,
            child: Text(num.toString()),
          ))
              .toList(),
          menuMaxHeight: 150,
        ),
      ],
    );
  }



}
