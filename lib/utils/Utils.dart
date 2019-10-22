import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportincharge_flutter/widgets/Dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

import 'GroupsAndVehicles.dart';

class Utils {

  void sendMail(String email, String subject, String body)=>launch('mailto:$email?subject=$subject&body=$body' );
  /*Shared Preference */
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  static addStringPref(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static addDoublePref(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  static addBoolPref(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<String> getStringPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> getBoolPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<int> getintPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<double> getDoublePref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  /*Toast*/

  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
  }

  static void eraseUserData() {
    Utils.addStringPref(
        GroupsAndVehicles.loginStatusLabel, GroupsAndVehicles.loggedInStatus);
    Utils.addStringPref(GroupsAndVehicles.accountIDLabel, null);
    Utils.addStringPref(GroupsAndVehicles.userIDLabel, null);
    Utils.addStringPref(GroupsAndVehicles.passwordLabel, null);
    Utils.addStringPref(GroupsAndVehicles.mapType, null);
    GroupsAndVehicles.accountID = null;
    GroupsAndVehicles.userID = null;
    GroupsAndVehicles.IMEI = null;
    GroupsAndVehicles.ipaddress = null;
    Utils.addStringPref(GroupsAndVehicles.IMEILabel, null);
    Utils.addStringPref(GroupsAndVehicles.ipAddressLabel, null);
  }

  static Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> userLoggedIn() async {
    String status =
        await Utils.getStringPref(GroupsAndVehicles.loginStatusLabel);
    if (identical(status, GroupsAndVehicles.loggedInStatus)) {
      return true;
    } else if (identical(status, GroupsAndVehicles.loggedOutStatus)) {
      return false;
    }
  }

  showDialog(BuildContext context) {
    Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
  }

  dismissDialog(BuildContext context) {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
        .pop(); //close the dialog
  }


  static launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
