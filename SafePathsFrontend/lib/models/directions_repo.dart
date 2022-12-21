import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:warn_me/constants.dart';
import 'package:warn_me/models/Directions.dart';
import 'package:http/http.dart' as http;

class DirectionsRepository {
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json";

  final Dio _dio;
  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    String request =
        '$baseUrl?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyDhbsD0Jwm5wNIQ54Vdh9mG2nxaxh2Y3q8';
    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return Directions.fromMap(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
