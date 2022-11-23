import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

import 'googlemap_api.dart';

class LocationTracking extends StatefulWidget {
  const LocationTracking({Key key}) : super(key: key);

  @override
  State<LocationTracking> createState() => _LocationTrackingState();
}

class _LocationTrackingState extends State<LocationTracking> {
  LatLng sourceLocation = const LatLng(28.432864, 77.002563);
  LatLng destinationLatlng = const LatLng(28.431626, 77.002475);

  bool isLoading = false;
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _marker = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  StreamSubscription<LocationData> subscription;

  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;

  @override
  void initState() {
    super.initState();
    print('sourceLocation');

    location = Location();
    polylinePoints = PolylinePoints();

    location?.onLocationChanged.listen((clocation) {
      currentLocation = clocation;

      print(currentLocation);
      print(currentLocation.latitude.toString() + 'hellooo');
    });
    setInitialLocation();
  }

  void setInitialLocation() async {
    currentLocation = await location?.getLocation();

    destinationLocation = LocationData.fromMap({
      "latitude": destinationLatlng.latitude,
      "longitude": destinationLatlng.longitude,
    });
  }

  void showLocationPins() {
    var sourceposition = LatLng(
        currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0);

    var destinationPosition =
        LatLng(destinationLatlng.latitude, destinationLatlng.longitude);

    _marker.add(Marker(
      markerId: const MarkerId('sourcePosition'),
      position: sourceposition,
    ));
    _marker.add(
      Marker(
        markerId: const MarkerId('destinationPosition'),
        position: destinationPosition,
      ),
    );
    setPolylinesInMap();
  }

  void setPolylinesInMap() async {
    var result = await polylinePoints?.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      PointLatLng(
          currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0),
      PointLatLng(destinationLatlng.latitude, destinationLatlng.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng) {
        polylineCoordinates
            .add(LatLng(PointLatLng.latitude, PointLatLng.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
          width: 5,
          polylineId: const PolylineId('polyline'),
          color: Colors.blueAccent,
          points: polylineCoordinates,
        ));
      });
      updatePinsOnMap();
    }
  }

  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 20,
      tilt: 80,
      target: LatLng(
          currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var sourcePosition = LatLng(
        currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0);

    setState(() {
      _marker.removeWhere((marker) => marker.mapsId.value == 'sourcePosition');

      _marker.add(Marker(
        markerId: const MarkerId('sourcePosition'),
        position: sourcePosition,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = const CameraPosition(
      zoom: 13.5,
      tilt: 50,
      bearing: 30,
      target: LatLng(0.0, 0.0),
    );
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          markers: _marker,
          polylines: _polylines,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);

            showLocationPins();
          },
        ),
      ),
    );
  }
}
