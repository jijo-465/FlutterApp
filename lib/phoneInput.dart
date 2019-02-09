import 'package:flutter/material.dart';
import 'otp_screen.dart';

class PhoneInput extends StatefulWidget{
  // PhoneInput({this.auth});
  // final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _phoneInput();
}

class _phoneInput extends State<PhoneInput>{
  String _phnum,verificationId,smsCode;
  final formKey=new GlobalKey<FormState>();
  var _phController= new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login Page'),
      ),
      body: Container(
        
            padding: EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter Phone number'),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: _phController,
                  validator: (value){
                    if(value.isEmpty){
                      
                      return 'Phone cant be empty';
                    }
                    else if(value.length<10){
                      return 'Invalid number';
                    }
                    else{
                      return null;
                    }
                  },
                  onSaved: (value)=>_phnum=value,
                ),
                RaisedButton(
                    onPressed: validateAndSubmit,
                    child: Text('Login'),
                    textColor: Colors.white,
                    elevation: 7.0,
                    color: Colors.blue)
                      ],
              ),
              
                    )),
                  );
              }
            
                    
   bool validatePhone() {
     final form=formKey.currentState;
     if(form.validate()){
       form.save();
       _phnum='+91'+_phnum;
       print('Valid. Phone $_phnum');
       return true;
     }else{
       print('Invalid');
       return false;
     }
     
  }

  void validateAndSubmit() async{
      if(validatePhone()){
        var route=new MaterialPageRoute(
          builder: (BuildContext)=>
          new OtpInput(phNumber: _phnum)
        );
        Navigator.of(context).push(route);
           //String userId=await widget.auth.signInWithPhone(verificationId, otp)
    }
  }
}