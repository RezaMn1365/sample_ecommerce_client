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
    // location = widget.initalLocation!.latLong!;
    // var locationMap = await Storage().getLocation();
    // var locationList = locationMap.latLong;
    // location[0] = locationList![0];
    // location[1] = locationList![1];
    // _image.image
    //     .resolve(ImageConfiguration())
    //     .addListener(ImageStreamListener((image, synchronousCall) {
    //   if (mounted) {
    //     setState(() {
    //       _loading = false;
    //     });
    //   }
    // }));

    // TODO: implement initState
    // renderUrl = _buildUrl();
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

  // Widget _buildWidget() {
  //   Image image = Image.network('test');
  //   final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
  //   stream.addListener(ImageStreamListener((image, synchronousCall) {
  //     onError:
  //     (dynamic exception, StackTrace stackTrace) {
  //       print('enter onError start');
  //       print(exception);
  //       print(stackTrace);
  //       print('enter onError end');
  //     };
  //   }));
  //   return image;
  // }

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
        // Navigation.gotoMapAddressPage(context);
        // widget.refreshCallBack(true);
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          // _buildWidget(),
          // _loading ? Text('Loading...') : _image,

          // CachedNetworkImage(
          //   errorWidget: (context, url, error) => Text('data'),
          //   placeholder: (context, url) => const CircularProgressIndicator(),
          //   imageUrl: 'https://picsum.photos/250?image=9',
          // ),

          // Container(
          //     decoration: BoxDecoration(
          //   image: DecorationImage(
          //     fit: BoxFit.cover,
          //     image: AssetImage('images/global_map.png'),
          //   ),
          // )),

          Image.network(
              // widget.location.latitude != 0 && widget.location.longitude != 0
              // ?
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

          // FadeInImage(
          //     repeat: ImageRepeat.repeat,
          //     // bundle:AssetImage('images/global_map.png' ),
          //     fit: BoxFit.cover,
          //     // placeholderErrorBuilder: (context, error, stackTrace) {
          //     //   return Image.asset('images/global_map.png');
          //     // },
          //     imageErrorBuilder: (context, error, stackTrace) {
          //       // print('Error');
          //       return const LinearProgressIndicator();
          //     },
          //     placeholderErrorBuilder: (context, error, stackTrace) =>
          //         const LinearProgressIndicator(),
          //     placeholder: const AssetImage('images/global_map.png'),
          //     image: location[0] != 0 && location[0] != 0
          //         ? NetworkImage(_buildUrl())
          //         : const AssetImage('images/global_map.png') as ImageProvider
          //     //  location[0] != 0 && location[0] != 0
          //     // ? 'https://picsum.photos/250?image=9' // _buildUrl()
          //     // : 'images/global_map.png'//'images/global_map.png',
          //     ),

          //   // child: Image.network(
          //   //   _buildUrl(),
          //   //   errorBuilder: (context, error, stackTrace) {
          //   //     return Image.asset('images/global_map.png');
          //   //   },
          //   // ),

          //   decoration: BoxDecoration(
          //     border: Border.all(style: BorderStyle.solid, color: Colors.white),
          //     //     // image:
          //     //     // location[0] != 0 && location[0] != 0
          //     //     //     ? DecorationImage(
          //     //     //         fit: BoxFit.cover,
          //     //     //         image: Image.network(
          //     //     //           _buildUrl(),
          //     //     //           errorBuilder: (context, error, stackTrace) {
          //     //     //             return Image.asset('images/global_map.png');
          //     //     //           },
          //     //     //         ) as ImageProvider)
          //     image: location[0] != 0 && location[1] != 0
          //         ? DecorationImage(
          //             image: NetworkImage(
          //               _buildUrl(),
          //             ),
          //             onError: (exception, stackTrace) {
          //               print('Error: $exception');
          //             },
          //           )
          //         : const DecorationImage(
          //             fit: BoxFit.cover,
          //             image: AssetImage('images/global_map.png'),
          //           ),
          //   ),
          // ),
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

    // InkWell(
    //   enableFeedback: true,
    //   splashColor: Colors.black,
    //   onTap: () {
    //     // Navigator.push(
    //     //   context,
    //     //   MaterialPageRoute(
    //     //     builder: (context) {
    //     //       return MapAddress();
    //     //     },
    //     //   ),
    //     // ).then(
    //     //   (value) => setState(() {}),
    //     // );
    //     // Navigation.gotoMapAddressPage(context);
    //     widget.refreshCallBack(true);
    //   },
    //   child: Stack(
    //     children: [
    //       Container(
    //         decoration: BoxDecoration(
    //           border: Border.all(style: BorderStyle.solid, color: Colors.white),
    //           image: widget.location[0] != 0 && widget.location[0] != 0
    //               ? DecorationImage(
    //                   fit: BoxFit.cover, image: NetworkImage(_buildUrl()))
    //               : const DecorationImage(
    //                   fit: BoxFit.cover,
    //                   image: AssetImage('images/global_map.png')),
    //         ),
    //       ),

    //       Positioned(
    //         top: 70,
    //         right: 100,
    //         child: Column(
    //           children: [
    //             Image.asset(
    //               'images/pin.png',
    //               alignment: Alignment.center,
    //               width: 50,
    //               height: 50,
    //             ),
    //             const Text(
    //               'Tap to choose your location!',
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             ),
    //           ],
    //         ),
    //       ),

    //       // ),
    //     ],
    //   ),
    // );

    //  Image.network(_buildUrl());
    // 'https://maps.googleapis.com/maps/api/staticmap?center=Iran,%20Tehran&zoom=11&size=600x400&key=AIzaSyC-Kt6Sijc8w7Oeg5ZRAMuxQrGoDr-a1ZI');
  }
}
