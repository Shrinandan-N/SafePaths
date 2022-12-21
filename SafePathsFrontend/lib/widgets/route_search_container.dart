import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';

class searchContainerState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => searchContainer();
}

class searchContainer extends State<searchContainerState> {
  var _searchController = TextEditingController();
  var _startController = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = "112233";
  List<dynamic> _places = [];
  bool _personalLocation = false;

  @override
  void initState() {
    _searchController.addListener(() {
      onChange();
    });
    _startController.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion(_searchController.text);
    getSuggestion(_startController.text);
  }

  void getSuggestion(String input) async {
    String apiKey = "AIzaSyDhbsD0Jwm5wNIQ54Vdh9mG2nxaxh2Y3q8";
    String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        '$baseUrl?input=$input&key=$apiKey&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _places = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load places');
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(onChange);
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.06,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5.0, 5.0, 10),
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Where are you headed?",
                    prefixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _personalLocation = !_personalLocation;
                          });
                        },
                        child: const Icon(Icons.arrow_circle_down)),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.green,
                    )),
                controller: _searchController,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        _personalLocation
            ? Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 5.0, 5.0, 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Starting location",
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.green,
                          )),
                      controller: _startController,
                    ),
                  ),
                ),
              )
            : SizedBox(),
        Container(
          height: size.height / 3,
          width: size.width * 0.9,
          decoration: BoxDecoration(
              color: _places.length > 0 ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(15)),
          child: ListView.builder(
              itemCount: _places.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    _searchController.text = _places[index]["description"];
                    String address = _places[index]["description"];
                    await http.post(Uri.parse(
                        "https://gtwl0n7r3c.execute-api.us-west-1.amazonaws.com/dev/%7Bproxy+%7D?address=${address}"));
                    setState(() {
                      _places = [];
                    });
                  },
                  child: ListTile(
                    tileColor: Colors.white,
                    leading: const Icon(Icons.place),
                    title: Text(_places[index]["description"]),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

//give curr location and final location, use google maps routing to find all the routes
