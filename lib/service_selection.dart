//import 'package:bertha_flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bertha_flutter/services/client_services.dart';
import 'service_list_tile.dart';

class ServiceSelection extends StatefulWidget{
  String washerName;
  String washerId;
    var services;
    ServiceSelection({Key key,this.washerName, this.services,this.washerId}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    
    return _serviceSelection();
  }

}

class _serviceSelection extends State<ServiceSelection>{
  //var _serviceNames;
  bool isChecked=false;
  List<Services> services=new List();
  Stream<QuerySnapshot> _serviceNames;
  ClientServices serviceObj=new ClientServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceObj.getServiceNames(widget.washerId).then((results){
      setState(() {
       _serviceNames=results; 
       
      });
      // _serviceNames.first.then((value){
      //   value.documents.forEach((doc){
      //     Services serv=new Services(doc.data['name']);
      //     services.add(serv);
      //   });
      // });
        // print(value.documents[1].data['name']))});
      // _serviceNames.forEach((value){
      //    print(value);
      //     value.documents.forEach((val){
      //       Services serv=new Services(val.data['name']);
      //       services.add(serv);
      //     });
      //  });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //appBar: AppBar(
        //title: Text('Select the services'),
      //),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
               children: <Widget>[
            
            Container(
              height: 100,
              width: 150,
                child:Image.asset('assets/wasser.png',fit: BoxFit.fill),
            ),
            
            Container(
              
              padding: EdgeInsets.all(14),
              child: Text(widget.washerName,style: TextStyle(
                fontSize: 18.0,
                color: Colors.blueAccent
              ),
              
              ),
            )
          ],
          
        ),
        Expanded(
          child: Container(
          //height: 500,
          child: serviceList(),
        ),
        )
        ,
          ],
        )
        
        
      ),
    );
  }

  Widget serviceList(){
    //print(services);
    // return ListView(
    //   padding: EdgeInsets.symmetric(vertical: 5.0),
    //   children: services.map((Services service){
    //     return ServiceListTile(services: service);
    //   }).toList(),
    // );
      return StreamBuilder(
        stream: _serviceNames,
        builder: (context,snapshot){
          if(snapshot.data!=null){
            return ListView.builder(
              
        itemCount: snapshot.data.documents.length,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (context,i){
          // setState(() {
          //   //Services serv=new Services(snapshot.data.documents[i].data['name']);
          //   services.add(Services(snapshot.data.documents[i].data['name']));
            
          // });
          //return ServiceListTile(name: snapshot.data.documents[i].data['name']);
          services.add(new Services(snapshot.data.documents[i].data['name']));
          
          return ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(snapshot.data.documents[i].data['name']),
                ),
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      services[i].isChecked=value;
                    });
                  }, 
                  value: services[i].isChecked,)
              ],

            ),
            onTap: (){},
          );
        },
      );

          }else return Container();
          
        }
      );
    

  }

}

class Services{
  String name;
  bool isChecked;
  Services(this.name){
    this.isChecked=false;
  }
}