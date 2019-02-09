import 'package:flutter/material.dart';
import 'wash_at_home.dart';
import 'service_selection.dart';

class ServiceDashboard extends StatefulWidget{
  String washerName;
  String washerId;
    var services;
    ServiceDashboard({Key key,this.washerName, this.services,this.washerId}):super(key: key);
 
  @override
  State<StatefulWidget> createState() {
    return _serviceDashboard();
  }

}

class _serviceDashboard extends State<ServiceDashboard>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.washerName),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Service at Home',icon: Icon(Icons.local_car_wash)),
              Tab(text: 'Book a Slot',icon:Icon(Icons.watch_later))
            ],
            
          ),
        ),
        body: TabBarView(
          children: <Widget>[
              WashAtHome(washerName:widget.washerName,washerId: widget.washerId,),
          ServiceSelection(washerId: widget.washerId,washerName: widget.washerName,services: widget.services)
 
          ],
        ),
      ),
    );
  }

}