import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'main_model.dart';

class ChangePasswordWidget extends StatelessWidget {
  ChangePasswordWidget({super.key});
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController retypePassword = TextEditingController();

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
                onPressed: _changePassword, child: const Text('Submit')),
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
    var passwordMatch = false;
    bool success = false;

    if (newPassword.text == retypePassword.text) {
      passwordMatch = true;
      //Create an instance of the current user.
      var user = await FirebaseAuth.instance.currentUser!;
      //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

      final cred = await EmailAuthProvider.credential(
          email: user.email!, password: oldPassword.text);
      await user.reauthenticateWithCredential(cred).then((value) async {
        await user.updatePassword(newPassword.text).then((_) {
          success = true;
        }).catchError((error) {
          print(error);
        });
      }).catchError((err) {
        print(err);
      });
    }
    //return success;
  }
}
