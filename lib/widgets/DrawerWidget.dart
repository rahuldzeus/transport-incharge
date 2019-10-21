import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:transportincharge_flutter/anim/SlideAnimation.dart';
import 'package:transportincharge_flutter/screens/HomeScreen.dart';
import 'package:transportincharge_flutter/screens/LoginPage.dart';
import 'package:transportincharge_flutter/utils/Utils.dart';
import 'package:app_settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class DrawerWidget extends StatelessWidget {
  final String title;

  DrawerWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Transport Incharge'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Reports'),
              leading: Icon(Icons.report),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Over Speed'),
              leading: Icon(Icons.blur_on),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('BreakDown Vehicles'),
              leading: Icon(Icons.blur_on),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Report Bug'),
              leading: Icon(Icons.blur_on),
              onTap: () async {
                // Update the state of the app
                // ...
                // Then close the drawer
                var dialog= await _asyncInputDialog(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Notification'),
              leading: Icon(Icons.blur_on),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.blur_on),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Utils().showDialog(context);
                Utils.eraseUserData();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
                Utils().dismissDialog(context);
              },
            ),
            ListTile(
              title: Text('Notification Settings'),
              leading: Icon(Icons.blur_on),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                AppSettings.openAppSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String issue= '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter the issue'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(labelText: 'Issue', hintText: 'eg. Button not working'),
                    onChanged: (value) {
                      issue = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Utils().sendMail("rahul.shwork@gmail.com");
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }

}
