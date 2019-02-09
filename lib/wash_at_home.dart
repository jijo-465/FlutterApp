import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'service_selection.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class WashAtHome extends StatefulWidget{
  final String washerName;
  final String washerId;
  WashAtHome({Key key,this.washerName,this.washerId}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    
    return _washAtHome(this.washerName);
  }
}

class _washAtHome extends State<WashAtHome>{
  String washerName;
  GoogleMapController myController;
var latitude;
var longitude;
var serviceLatitude;
var serviceLogitude;
String error;
 var currentLocation = <String, double>{};
 Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
 var startLocation = <String, double>{};
 var _location=new Location();
 bool mapToggle=false;
 bool markerLoaded= false;
 bool _permission = false;
 Image image1;
 bool currentWidget = true;
 
 final formKey=new GlobalKey<FormState>();
 var _addressController = new TextEditingController();
 String _serviceAddress;
 List<Placemark> placemark;
 //Future<Marker> mrkr;
 Marker mrkr;
 ArgumentCallbacks<Marker> cb;
 StreamSubscription<Map<String,double>> _locationSubscription;
  _washAtHome(this.washerName);

 initState(){
    super.initState();
    initPlatformState();
    // Geolocator().getCurrentPosition().then((currLoc){
    //   setState(() {
    //           currentLocation=currLoc;
    //           mapToggle=true;
    //         });
        
    // });
    
    _locationSubscription=_location.onLocationChanged().listen((Map<String,double> result){
        setState(() {
         _currentLocation=result; 
         mapToggle=true;
        });
    });
}
  initPlatformState() async {
    
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();


      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }
    setState(() {
        _startLocation = location;
    });

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;


    // if (_currentLocation == null) {
    //   widgets = new List();
    // } else {
    //   print(_currentLocation["latitude"]);
    //   widgets = [
    //     new Image.network(
    //         "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=18&size=640x400&key=AIzaSyBq8KiI5JXuni3xxGxk3Hzj__1PWfIdWqU")
    //   ];
    // }
    //     widgets.add(new Center(
    //     child: new Text(_startLocation != null
    //         ? 'Start location: $_startLocation\n'
    //         : 'Error: $error\n')));

    // widgets.add(new Center(
    //     child: new Text(_currentLocation != null
    //         ? 'Continuous location: $_currentLocation\n'
    //         : 'Error: $error\n')));

    // widgets.add(new Center(
    //   child: new Text(_permission 
    //         ? 'Has permission : Yes' 
    //         : "Has permission : No")));
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('select address'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: 
          <Widget>[
            Row(
               children: <Widget>[
            
            Container(
              height: 50,
              width: 150,
                //child:Image.asset('assets/wasser.png',fit: BoxFit.fill),
                child: Icon(Icons.directions_car),
            ),
             Container(              
              padding: EdgeInsets.all(14),
              child: Text(this.washerName,style: TextStyle(
                fontSize: 18.0,
                color: Colors.blueAccent
              )
              )
            )
          ]),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
                Container(
            height: 250,
            child: mapToggle? GoogleMap(
                  onMapCreated: (controller){
                    setState(() {
                        myController=controller;
                        cb=myController.onMarkerTapped;
                        cb.add(callback);
                        
                        myController.addListener(_mapMoved);
                        
                                                
                                            });
                                            
                                            //myController.addMarker(MarkerOptions(
                                            //     draggable: true,
                                            //     position: LatLng(_startLocation["latitude"], _startLocation["longitude"]),
                                                
                                            // )).then((value)=>mrkr=value);
                                            
                                            
                                            //addAssist();  
                                          },
                                          options: GoogleMapOptions(
                                            trackCameraPosition: true,
                                            scrollGesturesEnabled: true,
                                            myLocationEnabled: true,
                                            compassEnabled: true,
                                            cameraPosition: CameraPosition(
                                              target: LatLng(_startLocation["latitude"], _startLocation["longitude"]),
                                              zoom: 15.0
                                            )
                                          ),
                        
                                        ):Container(
                                          child: Icon(Icons.map),
                                        ),
                                  ),
                                  Center(
                                    child: IconButton(onPressed: () {print('pressed');}, icon: Icon(Icons.location_on),),
                                  )
            ],
          ),
          
                              
                                                      ]
                                                    )
                                                      
                                                    ),
                                                );
                                              }
                                              callback(Marker mk){
                                                  // _scaffoldKey.currentState.showBottomSheet((context){
                                                  //   return WasherBottomSheet(mk.options.clientId);
                                                  // });
                                                  print(mk.options.clientId);
                                                  
                                              }
                                            
                                            
                                              void _mapMoved() async{
                                                //print(myController.cameraPosition.target.latitude);
                                                // myController.updateMarker(mrkr, MarkerOptions(
                                                //   position: LatLng(myController.cameraPosition.target.latitude, myController.cameraPosition.target.longitude)
                                                // ));
                                                
                                                
                                                if(!myController.isCameraMoving){
                                                  serviceLatitude=myController.cameraPosition.target.latitude;
                                                  serviceLogitude=myController.cameraPosition.target.longitude;
                                                  placemark = await Geolocator().placemarkFromCoordinates(serviceLatitude, serviceLogitude);
                                                  // print(placemark[0].country);
                                                  // print(placemark[0].position);
                                                  // print(placemark[0].locality);
                                                  // print(placemark[0].administrativeArea);
                                                  // print(placemark[0].postalCode);
                                                  // print(placemark[0].name);
                                                  // print(placemark[0].subAdministratieArea);
                                                  // print(placemark[0].isoCountryCode);
                                                  // print(placemark[0].subLocality);
                                                  // print(placemark[0].subThoroughfare);
                                                  // print(placemark[0].thoroughfare);
                                                  _serviceAddress=placemark[0].subThoroughfare+', '+placemark[0].thoroughfare+', '+placemark[0].subLocality+', '+placemark[0].locality;
                                                  _addressController.text=_serviceAddress;
                                                  print(_serviceAddress);
                                                }
                                                
                      }
                    
                      void validateAndSubmit() {
  }
}