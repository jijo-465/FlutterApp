import 'package:flutter/material.dart';
import 'auth.dart';
import 'phoneInput.dart';
import 'dashboard.dart';
class RootPage extends StatefulWidget{
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState()=>new _RootPageState();
    
  }
  enum AuthStatus{
    notSignedIn,
    signedIn
  }
  
  class _RootPageState extends State<RootPage>{
    AuthStatus authstatus=AuthStatus.notSignedIn;
    @override
      void initState() {
        // TODO: implement initState
        super.initState();
        widget.auth.currentUser().then((userId){
            setState(() {
                          authstatus=userId==null? AuthStatus.notSignedIn:AuthStatus.signedIn;
                        });
        });
      }
  @override
  Widget build(BuildContext context) {
    switch(authstatus){
      case AuthStatus.notSignedIn:
        return new PhoneInput();
      case AuthStatus.signedIn:
        return new DashboardPage();
    }
  }
}