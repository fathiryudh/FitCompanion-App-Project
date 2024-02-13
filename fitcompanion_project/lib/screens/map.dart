import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapPage({
    Key key,
    @required this.latitude,
    @required this.longitude,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor _locIcon;
  final Set<Marker> listMarkers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _currentPos = CameraPosition(
      bearing: 0.0,
      target: LatLng(widget.latitude, widget.longitude),
      tilt: 60.0,
      zoom: 17,
    );
    return Scaffold(
      body: Container(
        child: GoogleMap(
          mapType: MapType.hybrid,
          myLocationEnabled: true,
          initialCameraPosition: _currentPos,
          markers: _locIcon != null
              ? Set.from(listMarkers)
              : {},
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
