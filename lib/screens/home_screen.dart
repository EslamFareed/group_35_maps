import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      target: LatLng(37.43296265331129, -122.08832357078792),
      zoom: 19.151926040649414);
  Set<Marker>? markers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onTap: (argument) {
          markers!.add(
            Marker(
              markerId: MarkerId("${markers!.length + 1}"),
              position: argument,
            ),
          );
          setState(() {});
        },
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: markers ?? {},
        polylines: {
          Polyline(
            polylineId: PolylineId("1"),
            points: [
              markers!.toList()[0].position,
              markers!.toList()[1].position
            ],
            color: Colors.blue,
            width: 4,
          ),
          Polyline(
            polylineId: PolylineId("2"),
            points: [
              markers!.toList()[2].position,
              markers!.toList()[3].position
            ],
            color: Colors.blue,
            width: 4,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
