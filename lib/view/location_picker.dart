import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerScreen({Key? key, this.initialLocation})
      : super(key: key);

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _controller;
  LatLng _selectedLocation = LatLng(31.582045, 74.329376); // Default to Lahore

  final List<Marker> _markers = <Marker>[
    Marker(
      markerId: MarkerId('selected-location'),
      position: LatLng(31.582045, 74.329376),
    ),
  ];

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _updateMarker(position);
    });
  }

  void _confirmLocation() {
    Navigator.pop(context, _selectedLocation);
  }

  Future<Position> getUserCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are denied");
      }
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      print("Error Getting Location: $error");
      rethrow; // rethrow the caught error to handle it outside this function if needed
    }
  }

  void LoadData() async {
    Position myLocation = await getUserCurrentLocation();
    if (mounted) {
      if (widget.initialLocation != null) {
        setState(() {
          _selectedLocation = widget.initialLocation!;
          _updateMarker(widget.initialLocation!);
        });
      } else {
        setState(() {
          _selectedLocation = LatLng(myLocation.latitude, myLocation.longitude);
          _updateMarker(_selectedLocation);
        });
      }
    }

    CameraPosition cameraPosition = CameraPosition(
        target: widget.initialLocation != null
            ? widget.initialLocation!
            : LatLng(myLocation.latitude, myLocation.longitude),
        zoom: 15);

    final GoogleMapController controller = _controller!;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    LoadData();
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchSuggestions(String query) async {
    if (query.isEmpty) return [];

    final String apiKey = 'AIzaSyDr0hRbqem82Vq9clqb4fsrZOqsN43aRnI';
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("RESPONSE FROM GOOGLE: ${response.body}");
      final List<dynamic> predictions =
          json.decode(response.body)['predictions'];
      return predictions.map((p) => p as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  Future<LatLng> getPlaceLatLng(String placeId) async {
    final String apiKey = 'AIzaSyDr0hRbqem82Vq9clqb4fsrZOqsN43aRnI';
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final location =
          json.decode(response.body)['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  void _updateMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selected-location'),
          position: position,
        ),
      );
    });

    CameraPosition cameraPosition = CameraPosition(
      target: position,
      zoom: 15,
    );

    _controller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: AppColor.primary,
            ),
            onPressed: _confirmLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: TypeAheadField<Map<String, dynamic>>(
              suggestionsCallback: fetchSuggestions,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search Places',
                    prefixIcon: Icon(Icons.search),
                  ),
                );
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion['description']),
                );
              },
              onSelected: (suggestion) async {
                final placeId = suggestion['place_id'];
                final LatLng position = await getPlaceLatLng(placeId);
                setState(() {
                  _selectedLocation = position;
                  _updateMarker(position);
                });
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _selectedLocation,
                zoom: 15,
              ),
              onTap: _onTap,
              markers: Set<Marker>.of(_markers),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        onPressed: () async {
          getUserCurrentLocation().then((value) {
            final LatLng position = LatLng(value.latitude, value.longitude);
            _updateMarker(position);
            setState(() {
              _selectedLocation = position;
            });
          });
        },
      ),
    );
  }
}
