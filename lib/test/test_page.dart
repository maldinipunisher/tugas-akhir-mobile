import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controller_mobile/models/models.dart';
import 'package:controller_mobile/services/services.dart';
import 'package:controller_mobile/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Arduino? arduino;

  @override
  void initState() {
    DataService.deviceId = "Madara313";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: DataService.getStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data!.data() as Map;
            arduino = Arduino("Madara313",
                trigger: data['trigger'],
                alarm: data['alarm'],
                firstStart: (data['waktu_mulai'] as Timestamp).toDate(),
                latitude: double.parse(data['latitude']),
                longtitude: double.parse(data['longtitude']),
                lock: data['lock'],
                lastOnline: (data['waktu'] as Timestamp).toDate(),
                status: data['status']);
          }

          return (snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.active)
              ? Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Arduino password:  ${arduino!.deviceId}"),
                      Text("Alarm Status:  ${arduino!.alarm}"),
                      Text(
                          "Coordinate :  ${arduino!.latitude}, ${arduino!.longtitude}"),
                      Text("Lock Status:  ${arduino!.lock}"),
                      Text(
                          "Device Last Online:  ${arduino!.lastOnline.toString()}"),
                      Text("Device Status:  ${arduino!.status}"),
                    ],
                  ),
                )
              : Scaffold(
                  body: Center(
                    child: SpinKitRing(color: accent1Color),
                  ),
                );
        });
  }
}
