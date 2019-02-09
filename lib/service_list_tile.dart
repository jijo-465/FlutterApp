import 'package:flutter/material.dart';
import 'services.dart';

class ServiceListTile extends StatefulWidget{
  //final Services services;
  final String name;

  ServiceListTile({Key key, this.name}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ServiceListTile(this.name);
  }

}

class _ServiceListTile extends State<ServiceListTile>{
  //final Services services;
  String name;
  bool isChecked=false;
  initState(){
    super.initState();
    print('Entered here');
  }

  _ServiceListTile(this.name);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      title: Row(children: <Widget>[
        Expanded(child: Text(this.name),),
        Checkbox(
          value: this.isChecked,
          onChanged: (value){
          setState(() {
           this.isChecked=value; 
          });
        },
        )
      ],),
    );
  }

}