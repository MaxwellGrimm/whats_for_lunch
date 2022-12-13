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
class ChangePasswordWidget extends StatelessWidget {
  ChangePasswordWidget({super.key});
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController retypePassword = TextEditingController();
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
                const Text('Username:    '),
                Text(mainModel
                    .getCurrentUserName()
                    .toString()) //this will be replaced with the actual user's username
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
            child: TextField(
              controller: oldPassword,
              obscureText: true,
              decoration: const InputDecoration(
                fillColor: Colors.black12,
                filled: true,
                labelText: 'Old Password',
                border: OutlineInputBorder(),
              ),
            ),
          ), //this will be replaced with the actual user's password

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
            child: TextField(
              controller: newPassword,
              obscureText: true,
              decoration: const InputDecoration(
                fillColor: Colors.black12,
                filled: true,
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            //this will be replaced with the actual user's password
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
            child: TextField(
              controller: retypePassword,
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
                  _changePassword();

                  if (success == true) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Successful'),
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
//should also return us to the My Profile page once we successfully change the password..
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
