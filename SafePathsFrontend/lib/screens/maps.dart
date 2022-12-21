import 'dart:async';
import 'dart:convert';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:warn_me/constants.dart';
import 'package:warn_me/models/Directions.dart';
import 'package:warn_me/models/directions_repo.dart';
import 'package:warn_me/models/polyline_response.dart';
import 'package:warn_me/widgets/markers.dart';
import 'package:warn_me/widgets/route_search_container.dart';
import 'package:http/http.dart' as http;

class MapState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Maps();
}

class Maps extends State<MapState> {
  LatLng _initialcameraposition = LatLng(37.8703, -122.295);
  Completer<GoogleMapController> _GMcontroller = Completer();
  late GoogleMapController _controller;
  late Position currentposition;
  var geoLocator = Geolocator();
  String totalDistance = "";
  String totalTime = "";
  List<Marker> _markers = [];

  String apiKey = googleApiKey;
  LatLng destination = const LatLng(31.5525789, 74.2813495);
  PolylineResponse polylineResponse = PolylineResponse();
  Set<Polyline> poly = {};

  // void locatePosition() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   currentposition = position;
  //
  //   LatLng latlngPosition = LatLng(37.8703, -122.295);
  //   CameraPosition cameraPosition =
  //       CameraPosition(target: latlngPosition, zoom: 17.0);
  //   _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //   drawPolyline();
  // }

  void getDestination() async {
    var data = await http.get(Uri.parse(
        "https://ce4mhsfnr1.execute-api.us-west-1.amazonaws.com/default/routing"));
    var j_data = jsonDecode(data.body);
    print(j_data.toString());
  }

  loadData() async {
    _markers = await loadMarkers();
    getDestination();
    //_markers.add(_berkMarker);
  }

  // static final Marker _berkMarker = Marker(
  //     markerId: MarkerId("blackwell"),
  //     infoWindow: InfoWindow(title: 'You are here'),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //     position: LatLng(37.8678, -122.2611));
  // static final CameraPosition _berk =
  //     CameraPosition(target: LatLng(37.8678, -122.2611), zoom: 16);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25),
                myLocationButtonEnabled: true,
                polylines: poly,
                markers: Set<Marker>.of(_markers),
                initialCameraPosition:
                    CameraPosition(target: _initialcameraposition),
                onMapCreated: (GoogleMapController controller) {
                  _GMcontroller.complete(controller);
                  _controller = controller;
                  //locatePosition();
                  drawPolyline();
                },
                //initialCameraPosition: _berk,
                mapType: MapType.normal,
                onTap: (LatLng pos) async {
                  return alert(context,
                      textOK: const Text(
                        "Submit report",
                        style: TextStyle(color: Colors.red),
                      ),
                      //TODO: display message "your report will be reviewed and updated accordingly"
                      title: Text("Report Crime"),
                      content: Container(
                        width: size.width / 2,
                        height: size.height / 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "Location: ${pos}"), //TODO: implement reverse geocode api
                            const TextField(
                              cursorColor: Colors.black,
                              decoration:
                                  InputDecoration(labelText: "Description"),
                            ),
                          ],
                        ),
                      ));
                },
              ),
              SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios)),
                    ),
                    Center(
                      child: searchContainerState(),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          );
        }
      },
    );
  }

  void drawPolyline() async {
    // var response = await http.post(Uri.parse(
    //     "https://maps.googleapis.com/maps/api/directions/json?key=" +
    //         apiKey +
    //         "&units=metric&origin=" +
    //         "${37.8678}" +
    //         "," +
    //         "${-122.2611}" +
    //         "&destination=" +
    //         "${37.8678}" +
    //         "," +
    //         "${-122.2552}" +
    //         "&mode=driving"));
    var response = await http.post(Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?key=" +
            apiKey +
            "&units=metric&origin=" +
            "${currentposition.latitude}" +
            "," +
            "${currentposition.longitude}" +
            "&destination=" +
            "${currentposition.latitude}" +
            "," +
            "${currentposition.longitude}" +
            "&mode=driving"));

    print(jsonDecode(response.body));

    polylineResponse = PolylineResponse.fromJson(jsonDecode(response.body));

    totalDistance = polylineResponse.routes![0].legs![0].distance!.text!;
    totalTime = polylineResponse.routes![0].legs![0].duration!.text!;

    for (int i = 0;
        i < polylineResponse.routes![0].legs![0].steps!.length;
        i++) {
      poly.add(Polyline(
          polylineId: PolylineId(
              polylineResponse.routes![0].legs![0].steps![i].polyline!.points!),
          points: [
            LatLng(
                polylineResponse
                    .routes![0].legs![0].steps![i].startLocation!.lat!,
                polylineResponse
                    .routes![0].legs![0].steps![i].startLocation!.lng!),
            LatLng(
                polylineResponse
                    .routes![0].legs![0].steps![i].endLocation!.lat!,
                polylineResponse
                    .routes![0].legs![0].steps![i].endLocation!.lng!),
          ],
          width: 3,
          color: Colors.red));
    }

    setState(() {});
  }
}
