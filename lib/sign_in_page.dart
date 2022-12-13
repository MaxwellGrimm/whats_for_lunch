// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'main_model.dart';
import 'spin_page.dart';
import 'auth/secrets.dart';

// ignore: slash_for_doc_comments
/**
Name: 
Date:
Description:
Bugs: 
Reflection: 
*/
class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);

    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, _) {
          if (FirebaseAuth.instance.currentUser != null) {
            mainModel.setCurrentUser(FirebaseAuth.instance.currentUser?.email,
                FirebaseAuth.instance.currentUser?.uid);
          }
          Navigator.pop(context);
        }),
      ],
      providerConfigs: [
        const EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId: mySecretKey,
        ),
      ],
    );
  }
}
