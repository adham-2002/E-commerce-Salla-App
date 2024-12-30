import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:project/root_screen.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with google",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      onPressed: () async {
        await signInWithGoogle2(context: context);
      },
    );
  }
}

Future<UserCredential> signInWithGoogle2({
  required BuildContext context,
}) async {
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

  final authResult = await FirebaseAuth.instance
      .signInWithCredential(GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  ));

  if (authResult.additionalUserInfo!.isNewUser) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user?.uid)
        .set({
      "userId": authResult.user?.uid,
      "userName": authResult.user?.displayName,
      "userImage": authResult.user?.photoURL,
      "userEmail": authResult.user?.email,
      "createdAt": Timestamp.now(),
      "userWish": [],
      "userCart": [],
    });
  }

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await Navigator.pushReplacementNamed(context, RootScreen.routName);
  });

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential> signInWithGoogle({required BuildContext context}) async {
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

  final authResult = await FirebaseAuth.instance
      .signInWithCredential(GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  ));

  if (authResult.additionalUserInfo!.isNewUser) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user?.uid)
        .set({
      "userId": authResult.user?.uid,
      "userName": authResult.user?.displayName,
      "userImage": authResult.user?.photoURL,
      "userEmail": authResult.user?.email,
      "createdAt": Timestamp.now(),
      "userWish": [],
      "userCart": [],
    });
  }

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await Navigator.pushReplacementNamed(context, RootScreen.routName);
  });

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}



// Future<void> _googleSignin({required BuildContext context}) async {
//     final googleSignIn = GoogleSignIn();
//     final googleAccount = await googleSignIn.signIn();

//     if (googleAccount != null) {
//       final googleAuth = await googleAccount.authentication;
//       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
//         try {
//           final authResult = await FirebaseAuth.instance.signInWithCredential(
//               GoogleAuthProvider.credential(
//                   accessToken: googleAuth.accessToken,
//                   idToken: googleAuth.idToken));
//         } on FirebaseException catch (e) {
//           WidgetsBinding.instance.addPostFrameCallback(
//             (_) async {
//               await MyAppMethods.showErrorORWarningDialog(
//                   context: context,
//                   subtitle: "an Error has been occured ${e.message}",
//                   fct: () {});
//             },
//           );

//           WidgetsBinding.instance.addPostFrameCallback(
//             (_) async {
//               Navigator.pushReplacementNamed(context, RootScreen.routName);
//             },
//           );
//         } catch (e) {
//           WidgetsBinding.instance.addPostFrameCallback(
//             (_) async {
//               await MyAppMethods.showErrorORWarningDialog(
//                   context: context,
//                   subtitle: "an Error has been occured $e",
//                   fct: () {});
//             },
//           );
//         }
//       }
//     }
//   }
