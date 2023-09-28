import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:haja/login/responder.dart';

class AuthApi {
  static Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // Or use signInWithRedirect
      // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
    } else {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  // static Future<UserCredential?> signInWithFacebook() async {
  //   if (kIsWeb) {
  //     // Create a new provider
  //     FacebookAuthProvider facebookProvider = FacebookAuthProvider();

  //     facebookProvider.addScope('email');
  //     facebookProvider.setCustomParameters({
  //       'display': 'popup',
  //     });

  //     // Once signed in, return the UserCredential
  //     return await FirebaseAuth.instance.signInWithPopup(facebookProvider);

  //     // Or use signInWithRedirect
  //     // return await FirebaseAuth.instance.signInWithRedirect(facebookProvider);
  //   } else {
  //     // Trigger the sign-in flow
  //     final LoginResult loginResult = await FacebookAuth.instance.login();

  //     if (loginResult.accessToken == null) {
  //       return null;
  //     }
  //     // Create a credential from the access token
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //     // Once signed in, return the UserCredential
  //     return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   }
  // }

  static void loginWithProvider(ResponseData response) async {
    try {
      if (response.provider == 'google') {
        await signInWithGoogle();
      }
      // else if (response.provider == 'facebook') {
      //   userCredential = await signInWithFacebook();
      // }
      else {
        throw Exception('Provider not supported');
      }

      response.failure = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        response.failure = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        response.failure = 'The account already exists for that email.';
      }
    } catch (e) {
      response.failure = 'Unkown Error: $e';
    }

    response.validated = true;
  }

  static void createNewUser(ResponseData response) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: response.user,
        password: response.pass,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      response.failure = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        response.failure = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        response.failure = 'The account already exists for that email.';
      }
    } catch (e) {
      response.failure = 'Unkown Error: $e';
    }

    response.validated = true;
  }

  static void updateUserProfile({
    String? displayName,
    String? photoURL,
    String? email,
  }) async {
    User? active = AuthApi.activeUserInformation;

    if (active == null) return;

    if (photoURL != null) {
      await active.updatePhotoURL(photoURL);
    }

    if (email != null) {
      await active.updateEmail(email);
    }

    if (displayName != null) {
      await active.updateDisplayName(displayName);
    }

    await active.reload();
  }

  static void login(ResponseData response) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: response.user,
        password: response.pass,
      );

      response.failure = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        response.failure = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        response.failure = 'Wrong password provided for that user.';
      }
    }

    response.validated = true;
  }

  static void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static User? get activeUserInformation {
    return FirebaseAuth.instance.currentUser;
  }

  static String? get activeUser {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      return currentUser.uid;
    }

    return null;
  }

  // static Future<String?> get activeTeam async {
  //   String? currentUser = AuthApi.activeUser;

  //   if (currentUser != null) {
  //     return ((await FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(currentUser)
  //                 .get())
  //             .data() ??
  //         {})['activeTeam'];
  //   }

  //   return null;
  // }
}
