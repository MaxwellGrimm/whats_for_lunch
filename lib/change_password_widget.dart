import 'package:flutter/material.dart';

class ChangePasswordWidget extends StatelessWidget {
  ChangePasswordWidget({super.key});
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController retypePassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              children: const [
                Text('Username:    '),
                Text(
                    'user_name') //this will be replaced with the actual user's username
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: oldPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Old Password',
                border: OutlineInputBorder(),
              ),
            ),
          ), //this will be replaced with the actual user's password

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: newPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            //this will be replaced with the actual user's password
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: retypePassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Retype New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                onPressed: changePassword, child: const Text('Submit')),
          ) //this will be replaced with the actual user's password
        ],
      ),
    );
  }

//checks to see if the old password is correct, checks if new passwords are identical
//changes old password to new password
//gives alert that password was changed successfully
//should also return us to the profile page once we successfully change the password..
  void changePassword() {}
}
