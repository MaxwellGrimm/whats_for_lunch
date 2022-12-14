// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:rxdart/rxdart.dart';
import 'main_model.dart';

// ignore: must_be_immutable
// ignore: slash_for_doc_comments
/**
Name: Xee Lo 
Date: Decemeber 12, 2023
Description: this is where the user will change their password
Bugs: NOT A BUG but user can not change password if they use a google sign in and 
did not register an account with us 
Reflection: Learned how to change password which was very useful 
*/
// ignore: must_be_immutable
class ChangePasswordWidget extends StatelessWidget {
  ChangePasswordWidget({super.key});
  TextEditingController oldPassword =
      TextEditingController(); //stores old password
  TextEditingController newPassword =
      TextEditingController(); //stores new password
  TextEditingController retypePassword =
      TextEditingController(); //stores the retype new password
  var success =
      false; //checks to see if password was changed successfully or not

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //dispplays the user's name
                const Text('Username:    '),
                Text(mainModel.getCurrentUserName().toString())
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
            child: TextField(
              controller: oldPassword, //takes the input for the old password
              obscureText: true,
              decoration: const InputDecoration(
                fillColor: Colors.black12,
                filled: true,
                labelText: 'Old Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
            child: TextField(
              controller: newPassword, //takes the input for the new password
              obscureText: true,
              decoration: const InputDecoration(
                fillColor: Colors.black12,
                filled: true,
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
            child: TextField(
              controller:
                  retypePassword, //takes the input for the retype new password
              obscureText: true,
              decoration: const InputDecoration(
                fillColor: Colors.black12,
                filled: true,
                labelText: 'Retype New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                onPressed: (() {
                  _changePassword(); //button to press if you want your password to be changed

                  if (success == true) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text(
                            'Successful'), //if it was successful a popup would tell you
                        content: const Text('Password was changed.'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text("Ok"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog(
                      //pop to show if password change was unsucessful
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Unsuccessful'),
                        content: const Text(
                            'Password could not be changed. Your old password may have been incorrect or your passwords did not match!'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  }
                }),
                child: const Text('Submit')),
          )
        ],
      ),
    );
  }

//checks to see if the old password is correct, checks if new passwords are identical
//changes old password to new password
//gives alert that password was changed successfully
//should also return us to the My Profile page once we successfully change the password.
  _changePassword() async {
    if (newPassword.text == retypePassword.text) {
      //Create an instance of the current user.
      // ignore: await_only_futures
      var user = await FirebaseAuth.instance.currentUser!;
      //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

      // ignore: await_only_futures
      final cred = await EmailAuthProvider.credential(
          email: user.email!, password: oldPassword.text);
      await user.reauthenticateWithCredential(cred).then((value) async {
        //reauthorizes the user so that it doesnt get signed out
        await user.updatePassword(newPassword.text).then((_) {
          success = true;
        }).catchError((error) {
          print(error);
        });
      }).catchError((err) {
        print(err);
      });
    }
  }
}
