import 'package:flutter/material.dart';
import 'package:imaginationevents/common/MyBookingList.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQrShow extends StatefulWidget {
  var tid;

  TicketQrShow({super.key, this.tid});

  @override
  State<TicketQrShow> createState() => _TicketQrShowState();
}

class _TicketQrShowState extends State<TicketQrShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tid),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: QrImageView(
              data: widget.tid.toString(),
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>MyBookingList())
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
