import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'main_model.dart';
import 'spain_page.dart';
import 'auth/secrets.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    print(mySecretKey);

    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, _) {
          String userName;
          String userId;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SpinPage()));
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
