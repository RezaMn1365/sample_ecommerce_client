import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_application_1/helpers/navigation.dart' as Navigation;
import 'package:flutter_application_1/helpers/storage/storage.dart';

class MapAddress extends StatefulWidget {
  final LatLng initialPosition;
  final void Function(LatLng location) onLocationUpdated;
  const MapAddress(this.initialPosition,
      {Key? key, required this.onLocationUpdated})
      : super(key: key);

  @override
  _MapAddressState createState() => _MapAddressState();
}

class _MapAddressState extends State<MapAddress> {
  LatLng mainPos = LatLng(29.5926, 52.5836);
  late GoogleMapController _mapController;
  final markers = <Marker>{};
  MarkerId markerId = const MarkerId("YOUR-MARKER-ID");
  final Location _location = Location();
  List<double> _locationDataList = [];
  bool approve = false;

  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    // markers.add(
    //   Marker(
    //     markerId: markerId,
    //     position: _initialPosition,
    //   ),
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Please choose your location'),
        // backgroundColor: Colors.red,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: widget.initialPosition, zoom: 10),

            myLocationEnabled: true,
            markers: markers, //_createMarker(),
            onMapCreated: _onMapCreat,
            onCameraMove: (position) {
              setState(() {
                mainPos = position.target;
                // print(mainPos.latitude);
                // print(mainPos.longitude);
                // markers.add(
                //   Marker(
                //     markerId: markerId,
                //     position: position.target,
                //     infoWindow: InfoWindow(
                //         title: '${mainPos.latitude} : ${mainPos.longitude}',
                //         snippet: 'Done!'),
                //   ),
                // );
              });
            },
          ),
          Positioned(
            // bottom: MediaQuery.of(context).size.height * 0.5,
            // right: MediaQuery.of(context).size.width * 0.5,
            child: Image.asset(
              'images/pin.png',
              width: 60,
              height: 60,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 50),
                        primary: Colors.grey.shade100,
                        onPrimary: Colors.grey.shade600,
                      ),
                      onPressed: () async {
                        var pos = await _location
                            .getLocation(); //async is very important
                        await _mapController.animateCamera(
                            //async is very important
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(pos.latitude!, pos.longitude!),
                                zoom: 15)));
                      },
                      child: const Text(
                        'Find My Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 50),
                        primary: Colors.grey.shade100,
                        onPrimary: Colors.grey.shade600,
                      ),
                      onPressed: () async {
                        await _ApproveCancelDialog();
                        if (approve == true) {
                          widget.onLocationUpdated(mainPos);
                          Navigation.goBack(context);
                        }
                      },
                      child: const Text(
                        'Select this Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onMapCreat(controller) async {
    _mapController = controller;
    ///////////////////////// to implement live location tracking
    // _location.onLocationChanged.listen((loc) {
    //   _mapController.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //           target: LatLng(loc.latitude!, loc.longitude!), zoom: 15)));
    // });
  }

  Future<void> _ApproveCancelDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('Alert!'),
                Text('Are you sure to select this location?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                approve = true;
                // widget.locationData(_locationDataList);
                Navigator.of(context).pop(context); //close dialog
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                approve = false;
                Navigator.of(context).pop(context); //close dialog
              },
            ),
          ],
        );
      },
    );
  }
}
