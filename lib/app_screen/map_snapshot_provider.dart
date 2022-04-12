//Static MAP API-KEY:  AIzaSyC-Kt6Sijc8w7Oeg5ZRAMuxQrGoDr-a1ZI
//Sample URL: https://maps.googleapis.com/maps/api/staticmap?center=20.0902%2C-95.7192&zoom=14&size=600x400&key=AIzaSyC-Kt6Sijc8w7Oeg5ZRAMuxQrGoDr-a1ZI
//Document Link: https://developers.google.com/maps/documentation/maps-static/start

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_google_page.dart';

class MapSnapShotProvider extends StatefulWidget {
  final LatLng location;
  final void Function(LatLng location) onLocationUpdated;

  // final LocationModel? initalLocation;
  MapSnapShotProvider(
    this.location, {
    Key? key,
    required this.onLocationUpdated,
    // required this.initalLocation
  }) : super(key: key);
  String googleMapsApiKey = 'AIzaSyC-Kt6Sijc8w7Oeg5ZRAMuxQrGoDr-a1ZI';

  @override
  _MapSnapShotGeneratorState createState() => _MapSnapShotGeneratorState();
}

class _MapSnapShotGeneratorState extends State<MapSnapShotProvider> {
  // Uri renderUrl = Uri.http('google.com', '/a%2F');
  static const int defaultWidth = 800;
  static const int defaultHeight = 600;
  Map<String, String> defaultLocation = {
    "latitude": '35.6892',
    "longitude": '51.3890'
  };
  String renderUrl = 'google.com';

  // Image _image = new Image.network(
  //   '',
  // );
  // bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

//++++++++ REDUCE SIZE to 500x300
  String _buildUrl() {
    var baseUri = Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {
          'size': '500x300',
          'center': '${widget.location.latitude},${widget.location.longitude}',
          'zoom': '18',
          'key': widget.googleMapsApiKey,
        });
    print(baseUri.toString());

    return baseUri.toString();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      canRequestFocus: false,
      enableFeedback: false,
      splashColor: Colors.black,
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MapAddress(
                widget.location,
                onLocationUpdated: widget.onLocationUpdated,
              );
            },
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Image.network(
              widget.location.latitude != 0.1 &&
                      widget.location.longitude != 0.1
                  ? _buildUrl()
                  : '',
              // : '',
              errorBuilder:
                  (BuildContext context, Object exception, stackTrace) =>
                      Container(
                          decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/global_map.png'),
                        ),
                      )),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return child;
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),

          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/pin.png',
                  width: 40,
                  height: 40,
                ),
                const Text(
                  'Tap to choose your location!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // ),
        ],
      ),
      // ),
    );
  }
}
