import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class ClientServices{
  String serviceId;
  bool isLoggedIn(){
    if(FirebaseAuth.instance.currentUser()!=null){
      return true;

    }else{
      return false;
    }
  }

  getClientId() async{
    String clientId;

  }

  Future<QuerySnapshot> getDocs(String name) async{
    QuerySnapshot docs;
    await Firestore.instance.collection(name).getDocuments().then((value) {

      docs= value;
  });
  
  return docs;
  }

  getClientNames() async{
    List<String> clientNames;
    await Firestore.instance.collection('washers').getDocuments().then((docs) {
        if(docs.documents.isNotEmpty){
          for(int i=0;i<docs.documents.length;i++){
            clientNames.add(docs.documents[i].data['name']);
          }
        }
      });
    return clientNames;
  }

  getServiceNames(String clientId) async{
    
    return Firestore.instance.collection('clients').document(clientId).collection('services').snapshots();
  }

  Future<String> getClientNameById(String clientId) async{
    String name;
    await Firestore.instance.collection('clients').document(clientId).get().then((value){
        name=value.data['name'];
    });
    return name;
  }

}