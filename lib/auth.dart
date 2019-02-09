import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<String> signInWithPhone(String verificationId,String otp);

  Future<String> verifyPhone(String phone);
  Future<String> currentUser();
}

class Auth implements BaseAuth{
  String verificationId,phoneNo;
  
  
  @override
  Future<String> signInWithPhone(String verificationId, String otp) async {
    FirebaseUser user= await FirebaseAuth.instance.signInWithPhoneNumber(smsCode: otp, verificationId: verificationId);
    return user.uid;
  }
  
  Future<String> verifyPhone(String phone) async {
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
        phoneNumber: phone,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed
        );
  }
  Future <String> currentUser() async{
    FirebaseUser user= await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

}