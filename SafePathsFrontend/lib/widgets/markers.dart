import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<String> images = [
  'assets/yellow.png',
  'assets/orange.png',
  'assets/red.png'
];

Future<Uint8List> getImages(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<List<Marker>> loadMarkers() async {
  List<LatLng> latlongs = [];
  List<String> locations = [];
  List<int> crimeScores = [];
  var response = await http.get(Uri.parse(
      "https://gcr8xsb0a0.execute-api.us-west-1.amazonaws.com/default/list"));
  var data = jsonDecode(response.body);
  for (var d in data) {
    if (d["latitude"] < 38.0 &&
        d["latitude"] > 37.0 &&
        d["longitude"] > -123 &&
        d["longitude"] < -122) {
      latlongs.add(LatLng(d["latitude"], d["longitude"]));
      locations.add(d["address"].toString());
      crimeScores.add(d["crime_score"]);
    }
  }

  List<Marker> markers = [];
  final Uint8List markIcons_Y = await getImages(images[0], 50);
  final Uint8List markIcons_O = await getImages(images[1], 50);
  final Uint8List markIcons_R = await getImages(images[2], 50);

  for (int i = 0; i < 30; i++) {
    if (crimeScores[i] < 3) {
      markers.add(
        Marker(
          // given marker id
          markerId: MarkerId(locations[i]),
          // given marker icon
          icon: BitmapDescriptor.fromBytes(markIcons_Y),
          // given position
          position: latlongs[i],
          infoWindow: InfoWindow(
            title: 'Location: ${locations[i]}',
          ),
        ),
      );
    } else if (crimeScores[i] >= 3 && crimeScores[i] < 6) {
      markers.add(
        Marker(
          // given marker id
          markerId: MarkerId(locations[i]),
          // given marker icon
          icon: BitmapDescriptor.fromBytes(markIcons_O),
          // given position
          position: latlongs[i],
          infoWindow: InfoWindow(
            title: 'Location: ${locations[i]}',
          ),
        ),
      );
    } else {
      markers.add(
        Marker(
          // given marker id
          markerId: MarkerId(locations[i]),
          // given marker icon
          icon: BitmapDescriptor.fromBytes(markIcons_R),
          // given position
          position: latlongs[i],
          infoWindow: InfoWindow(
            title: 'Location: ${locations[i]}',
          ),
        ),
      );
    }
  }
  return markers;
}
