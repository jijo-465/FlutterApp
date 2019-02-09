
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class Test extends StatefulWidget{
  //OtpInput.auth({this.auth});
  
  
  @override
  State<StatefulWidget> createState() => new _test();
}

class _test extends State<Test>{
  var latitude;
var longitude;
 var currentLocation;
 bool mapToggle =false;
 var markerId;
 
 MapController cntrl;
  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currLoc){
      setState(() {
              currentLocation=currLoc;
              latitude=currentLocation.latitude;
              longitude=currentLocation.longitude;
              mapToggle=true;
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mapToggle?FlutterMap(
        mapController: cntrl,
        options: MapOptions(
          center: new LatLng(currentLocation.latitude, currentLocation.longitude),
          minZoom: 1.0,
          zoom: 14.0
          
        ),
        layers: [TileLayerOptions(
          urlTemplate: "https://api.mapbox.com/styles/v1/jijo0465/cjr7yy8p0049y2sphe4tfgtxt/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiamlqbzA0NjUiLCJhIjoiY2pyN3l3a2xqMDE4NjQ5dm1ta214cWZqdCJ9.xPsDiSp6-OY7qCgg9AtzlQ",
          additionalOptions: {
         'accessToken': 'pk.eyJ1IjoiamlqbzA0NjUiLCJhIjoiY2pyN3o2NmxkMDEzaDQ1bWxteXdobWQyNyJ9.xMGNrr0kYaQqpUDRkB6ymw',
         'id': 'mapbox.streets',
         
          },
          ),
          MarkerLayerOptions(
            markers: [Marker(
              id: 'abc',
              
              point: LatLng(currentLocation.latitude, currentLocation.longitude),
              builder: (context) => new Container(
                          child: IconButton(
                            id: 'ass',
                            icon: Icon(Icons.location_on),
                            color: Colors.red,
                            iconSize: 45.0,
                            onPressed: () {

                              
                              print('Marker tapped');
                              markerTapped('as');
                            },
                          ),
                        )),
                        Marker(
              
              point: LatLng(currentLocation.latitude-0.01, currentLocation.longitude),
              builder: (context) => new Container(
                          child: IconButton(
                            icon: Icon(Icons.location_on),
                            color: Colors.red,
                            iconSize: 45.0,
                          ),
                        ))
          
            ])
          ],
        ):null
      );
  }
  markerTapped(asd){
      
  }
  }

