import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:warn_me/screens/maps.dart';
import 'package:warn_me/widgets/markers.dart';
import 'package:warn_me/widgets/report_crime.dart';
import 'package:warn_me/widgets/route_search_container.dart';
import 'package:warn_me/widgets/textfield.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Dashboard();
}

class Dashboard extends State<DashboardScreen> {
  bool reported = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      body: Stack(
        children: [
          MapState(),
          SizedBox(
            height: size.height * 0.67,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 120.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: reported
                  ? Text(
                      "Select location of crime",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )
                  : SizedBox(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  child: ReportCrimeWidget(),
                  onTap: () {
                    //TODO: implement two finger tap to place location
                    setState(() {
                      reported = !reported;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
