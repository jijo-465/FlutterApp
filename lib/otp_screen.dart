import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

class OtpInput extends StatefulWidget{
  //OtpInput.auth({this.auth});
  final BaseAuth auth;
  String phNumber;
  OtpInput({Key key,this.phNumber, this.auth}):super(key: key);
  
  @override
  State<StatefulWidget> createState() => new _otpInput();
}

class _otpInput extends State<OtpInput>{
  String _otp,verificationId,smsCode;
  final formKey=new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Otp Page'),
      ),
      body: Container(
            padding: EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter otp'),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Otp cant be empty';
                    }
                    else if(value.length<6){
                      return 'Invalid Otp';
                    }
                    else{
                      return null;
                    }
                  },
                  onSaved: (value)=>_otp=value,
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
            
                    
   bool validateOtp() {
     final form=formKey.currentState;
     if(form.validate()){
       form.save();
       return true;
     }else{
       return false;
     }
     
  }

  void validateAndSubmit() async{
      if(validateOtp()){
        print('ewf');
        verifyPhone();
        print('$verificationId');
        // FirebaseAuth.instance.currentUser().then((user) {
        //   if(user.uid!=null){
        //     print(user.uid);
        //     Navigator.of(context).pushReplacementNamed('/homepage');
        //   }else{
        //     signIn();
        //   }
            
        // });
        signIn();
        
      }
  }

      Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
 
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };
 
    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      print('verified');
    };
 
    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };
 
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phNumber,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed
        );
  }
  Future<String> signInWithPhone(String verificationId, String otp) async {
    FirebaseUser user= await FirebaseAuth.instance.signInWithPhoneNumber(smsCode: otp, verificationId: verificationId);
    return user.uid;
  }
  signIn() {
    FirebaseAuth.instance
        .signInWithPhoneNumber(verificationId: verificationId, smsCode: _otp)
        .then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print(e);
    });
  }
}