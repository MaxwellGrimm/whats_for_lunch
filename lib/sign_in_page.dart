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
Name: Maxwell Grimm
Date: 12/14/2022
Description: This is the firebase sign in page
Bugs: Google sign in does not always work I think it may have to do with 
someone pushed a commit that got rid of some permissions.
Reflection: This was not hard with firebase but some git problems are what 
caused the errors I think
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
            //this sets in the main model the current signed in user email
            //that way we don't need to keep asking firbase
            //it kind of works like a session so if you clear your history on the 
            //app you will be signed out 
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
