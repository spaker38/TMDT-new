import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CurrentUser2 extends ChangeNotifier {
  String _uid;
  String _email;

  String get getUid => _uid;

  String get getEmail => _email;

  FirebaseAuth _auth = FirebaseAuth.instance;

  BuildContext get context => null;

  Future<String> signUpUser(String email, String password) async {
    String retVal = 'error';

    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_authResult.user != null) {
        _uid = _authResult.user.uid;
        _email = _authResult.user.email;
        retVal = "success";
      }
    }
//  catch(e){
//      retVal = e.massage;
//  }
    catch(signUpError){
      if(signUpError is PlatformException){
        if(signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE'){
        }
      }
    }
    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async{
    String retVal = 'error';

    try{
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if(_authResult.user != null){
        _uid = _authResult.user.uid;
        _email = _authResult.user.email;
        retVal = 'success';

      }

    }catch(e){
      retVal = e.message;
    }
    return retVal;
  }


  Future<String> loginUserWithGoogle(String email, String password) async{
    String retVal = 'error';
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try{
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential =  GoogleAuthProvider.getCredential(idToken: (_googleAuth.idToken), accessToken: _googleAuth.accessToken);
      AuthResult _authResult = await _auth.signInWithCredential(credential);

      if(_authResult.user != null){
        _uid = _authResult.user.uid;
        _email = _authResult.user.email;
        retVal = 'success';
      }

    }catch(e){
      retVal = e.message;
    }
    return retVal;
  }
}



