import 'package:bertha_flutter/service_selection.dart';
import 'package:bertha_flutter/wash_at_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 
import 'services/client_services.dart';
import 'package:bertha_flutter/service_dashboard.dart';

class WasherBottomSheet extends StatefulWidget{
  String washerId;
  
  
  WasherBottomSheet(String clientId){
    this.washerId=clientId;
  }

  @override
  State<StatefulWidget> createState() => _washerBottomSheet();

}

class _washerBottomSheet extends State<WasherBottomSheet>{
  String clientName;
  Stream<QuerySnapshot> _serviceNames;
  bool gotName =false;
  ClientServices serviceObj=new ClientServices();
  @override
    initState(){
      super.initState();
      //   Firestore.instance.collection('clients').getDocuments().then((docs) {
      //   if(docs.documents.isNotEmpty){
      //     for(int i=0;i<docs.documents.length;i++){
      //       if(widget.washerId==docs.documents[i].documentID){
      //         setState(() {
      //                         clientName=docs.documents[i]['name'];
      //                         gotName=true;
      //                       });
      //       }
            
            
      //     }
      //   }
       
      // });
      serviceObj.getClientNameById(widget.washerId).then((value){
        setState(() {
          clientName=value;
          gotName=true;
        });
          
      }).then((value){
          serviceObj.getServiceNames(widget.washerId).then((results){
          setState(() {
          _serviceNames=results; 
        });
    });
      });      
    }
  @override
  Widget build(BuildContext context) {
    
    if(gotName&&_serviceNames!=null){
      return Stack(children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                height: 300,
                width: 500,
                child: 
                Column(
                  children: <Widget>[
                      Row(
                  children: <Widget>[
                    Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(clientName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 24.0
                    )
                  )
                ),
              SmoothStarRating(
              starCount: 5,
              rating: 3,
              size: 20.0,
              color: Colors.green,
              borderColor: Colors.green,
            ),
            
            ]
         ),
         Container(
           alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text('Services',
              style:TextStyle(
                fontSize:18.0,
                color: Colors.blue
              )
              ),
            ),
         Container(
           padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
           child: serviceList(),
           height: 175,

            
         )
         
                
                  ])
                
         
           ),
               
              Positioned(
                
                bottom: 0.0,
                left: 50.0,
                right: 0.0,
                height: 60.0,
                //padding: EdgeInsets.all(20),
                child:Center(
                  
                  child: Row(
                    children: <Widget>[
                      RaisedButton(
                  child: Text('Book a Slot'), 
                  onPressed: () {
                  var route=new MaterialPageRoute(
          builder: (BuildContext)=>
          new ServiceSelection(washerName: clientName,services: _serviceNames,washerId: widget.washerId,)
        );
        Navigator.of(context).push(route);
                },
              ),
              RaisedButton(
                  child: Text('WashAtHome'), 
                  onPressed: () {
                  var route=new MaterialPageRoute(
          builder: (BuildContext)=>
          new WashAtHome(washerName: clientName,washerId: widget.washerId,)
        );
        Navigator.of(context).push(route);
                },
              )
                    ],
                  ),
                )
                
              )
              
      ],)
     ;
    }else{
        return Text('Loading...');
    }
    
  }
  Widget serviceList(){
      return StreamBuilder(
        stream: _serviceNames,
        builder: (context,snapshot){
          if(snapshot.data!=null){

          return ListView.builder(
        itemCount: snapshot.data.documents.length,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (context,i){
          return ListTile(
            title: Text(snapshot.data.documents[i].data['name']),
            onTap: (){},
          );
        },
      );

          }else{
            return Text('Loading');
          }
          
        }
      );
    }

  }

