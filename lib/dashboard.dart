import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'login.dart';
import 'washer_bottom_sheet.dart';
import 'services/client_services.dart';
 
class DashboardPage extends StatefulWidget {
  
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn
}
 
class _DashboardPageState extends State<DashboardPage> {
  final _scaffoldKey= new GlobalKey<ScaffoldState>();
  String uid = '';
 GoogleMapController myController;
var latitude;
var longitude;

 var currentLocation;
 bool mapToggle=false;
 bool markerLoaded= false;
 ClientServices serviceObj=new ClientServices();
 Future<Marker> mrkr;
 Drawer drawer = new Drawer();
 AuthStatus authStatus ;
 ArgumentCallbacks<Marker> cb;

  _DashboardPageState();
  getUid() {}

 
  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currLoc){
      setState(() {
              currentLocation=currLoc;
              mapToggle=true;
            });
        
    });
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
        print(uid);
        authStatus =uid==null?AuthStatus.notSignedIn: AuthStatus.signedIn;
      });
    }).catchError((e) {
      print(e);
    }); 
  }
  @override
  Widget build(BuildContext context) {
    if(authStatus!=null){
    switch(authStatus){
      case AuthStatus.notSignedIn:
      return new LoginScreen();
      case AuthStatus.signedIn:
          return Scaffold(
            key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Title'),
      ),
      drawer: drawer,
          body: Stack(
            children: <Widget>[
                mapToggle? GoogleMap(
                  onMapCreated: (controller){
                    setState(() {
                        myController=controller;
                        cb=myController.onMarkerTapped;
                        cb.add(callback);
                    });
                    
                    mrkr=myController.addMarker(MarkerOptions(
                        draggable: false,
                        position: LatLng(currentLocation.latitude, currentLocation.longitude),
                        
                    ));
                    
                    addAssist();  
                  },
                  options: GoogleMapOptions(
                    
                    compassEnabled: true,
                    cameraPosition: CameraPosition(
                      target: LatLng(currentLocation.latitude, currentLocation.longitude),
                      zoom: 15.0
                    )
                  ),

                ):Center(child: Text('Loading Please wait '),),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Assist'),
                          onPressed: addAssist,
                          
                        ),
                        RaisedButton(
                          child: Text('Wash'),
                          onPressed: addWasher,
                          
                        ),
                        RaisedButton(
                          child: Text('Service'),
                          onPressed: ()=>print('Menu 2 pressed'),
                          ),
                        RaisedButton(child: Text('Towing'),
                        onPressed: (){
                          print('$uid');
                          },
                        )
                      ],
                    )
                  ),
                  )
            ],
          )

    ); 
    }
    }else {
      return Scaffold(
        body: Center(
          child: Icon(Icons.directions_car),
        ),
      );
    }
  }

  addAssist() {
    //var clients=[];
    QuerySnapshot docs;
    myController.clearMarkers();
    
    myController.addMarker(MarkerOptions(
        draggable: false,
        position: LatLng(currentLocation.latitude, currentLocation.longitude)
    ));
    serviceObj.getDocs('clients').then((value){
      docs=value;
      for(int i=0;i<docs.documents.length;i++){
            if(docs.documents.isNotEmpty){
            //clients.add(docs.documents[i].data);
            initMarker(docs.documents[i].data,docs.documents[i].documentID);
          }
        }
      });
    //print(docs.documents[1]['name']);
  
      // Firestore.instance.collection('clients').getDocuments().then((docs) {
      //   if(docs.documents.isNotEmpty){
      //     for(int i=0;i<docs.documents.length;i++){
      //       clients.add(docs.documents[i].data);
      //       initMarker(docs.documents[i].data,docs.documents[i].documentID);
      //     }
      //   }
      // });
  }

  addWasher() async{
    QuerySnapshot docs;
    var washers=[];
    myController.clearMarkers();
    myController.addMarker(MarkerOptions(
        draggable: false,
        position: LatLng(currentLocation.latitude, currentLocation.longitude)
    ));
    serviceObj.getDocs('washers').then((value){
      docs=value;
      for(int i=0;i<docs.documents.length;i++){
            if(docs.documents.isNotEmpty){
            //washers.add(docs.documents[i].data);
            initMarker(docs.documents[i].data,docs.documents[i].documentID);
          }
        }
      });

      
      
      
  }

  initMarker(clients,clientId) async{
    
      mrkr=myController.addMarker(
        MarkerOptions(
          clientId: clientId,
          position: LatLng(clients['location'].latitude , clients['location'].longitude),
          draggable: false,
          infoWindowText: InfoWindowText(clients['name'], 'Info'),
        )
      );
  }

  callback(Marker mk){
      _scaffoldKey.currentState.showBottomSheet((context){
        return WasherBottomSheet(mk.options.clientId);
      });
      print(mk.options.clientId);
      
  }
}
