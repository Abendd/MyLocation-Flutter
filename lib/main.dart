import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double latitude;
  double longitude;
  GoogleMapController _controller;
  List<Marker> allMarkers = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      latitude = 40.7128;
      longitude = -74.0060;
    });
    allMarkers.add(
      Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(latitude, longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 12,
                ),
                onMapCreated: mapCreated,
                markers: Set.of(allMarkers),
              ),
            ),
            Text(
              latitude.toString(),
            ),
            Text(
              longitude.toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: getLocation,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
      print(
          '------------------------------------------------asdasd---------------');
    });
  }

  void getLocation() async {
    LocationData currentLocation;

    var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      LocationData currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        //error = 'Permission denied';
      }
      currentLocation = null;
    }

    location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 12,
          bearing: 45,
          tilt: 45,
        ),
      ));

      allMarkers.clear();
      allMarkers.add(
        Marker(
          markerId: MarkerId('myMarker'),
          draggable: false,
          onTap: () {
            print('Marker Tapped');
          },
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
        ),
      );

      setState(() {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    });
  }
}
