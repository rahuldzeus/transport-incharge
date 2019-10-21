import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:transportincharge_flutter/anim/SlideAnimation.dart';
import 'package:transportincharge_flutter/models/Login.dart';
import 'package:transportincharge_flutter/screens/HomeScreen.dart';
import 'package:transportincharge_flutter/utils/GroupsAndVehicles.dart';
import 'package:transportincharge_flutter/utils/Strings.dart';
import 'package:transportincharge_flutter/utils/Utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String modifiedRequest;
  Login modifiedBody;
  final accountIdController = TextEditingController();
  final userIDController = TextEditingController();
  final passwordController = TextEditingController();
  var imei;
  String version;
  String token;
  FirebaseMessaging _firebaseMessaging;
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;

  Location location = new Location();

  void initPlatformState() async {
    /*Below values are to be sent to API*/
    imei = await ImeiPlugin.getImei();
    token = await FirebaseMessaging().getToken();

    Map<String, double> newLocation;
    String error = "";
    try {
      newLocation = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if (e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Permission Denied- Please enable it from setting';
      newLocation = null;
    }
    setState(() {
      currentLocation = newLocation;
    });
  }

  @override
  void initState() {
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    initPlatformState();
    locationSubscription =
        location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        currentLocation = result;
        if ((currentLocation['latitude'] != 0.0) &&
            (currentLocation['longitude'] != 0.0)) {
/*Store the latitude and longitude in SharedPreferences/Preferences*/
          Utils.addStringPref(GroupsAndVehicles.latitudeLabel,
              currentLocation['latitude'].toString());
          Utils.addStringPref(GroupsAndVehicles.longitudeLabel,
              currentLocation['longitude'].toString());
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    accountIdController.dispose();
    userIDController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: FlutterLogo(
                    size: 200,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 20.0, right: 20.0),
                          child: TextFormField(
                            controller: accountIdController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_circle),
                                hintText: 'Bhashyam',
                                border: OutlineInputBorder()),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 20.0, right: 20.0),
                          child: TextFormField(
                            controller: userIDController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.verified_user),
                                hintText: 'admin',
                                border: OutlineInputBorder()),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 20.0, right: 20.0),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                hintText: 'bhashyamadmin',
                                border: OutlineInputBorder()),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 28.0, top: 10.0, left: 20.0, right: 20.0),
                        child: RaisedButton(
                          padding: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          elevation: 6.0,
                          color: Colors.lightBlue,
                          onPressed: () {
                            setState(() async {
                              bool val = await Utils.isInternetConnected();
                              if (val) {
                                Utils().showDialog(context);
                                getLogin();
                                Utils().dismissDialog(context);
                              } else {
                                Utils.showToast(Strings.noInternetConnection);
                              }
                            });
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /*Below method will fetch the data from Network*/
  getLogin() async {
    var latitude = await Utils.getStringPref(GroupsAndVehicles.latitudeLabel);
    var longitude = await Utils.getStringPref(GroupsAndVehicles.longitudeLabel);
    final response = await http.get(
        'http://track.glovision.co/callerlocation/login.php?accountID=Bhashyam&userID=admin&password=bhashyamadmin&imei=$imei&lat=$latitude&lng=$longitude&tokenid=$token&version=$version');
/*
final response = await http.get(
        'http://track.glovision.co/callerlocation/login.php?accountID=${accountIdController.text}&userID=${userIDController.text}&password=${passwordController.text}&imei=$imei&lat=$latiaopen gmaitter
        tude&lng=$longitude&tokenid=${_firebaseMessaging.getToken()}&version=$version');
*/

    if (response.statusCode == 200) {
      /*Write this block in Common Class*/
      modifiedRequest = response.body;
      /*Because of invalid JSON response, quotes are applied to make it valid JSON*/
      correctJSON(modifiedRequest);

      if (modifiedBody.markers == ' yes') {
        //Token is nested inside data field so it goes one deeper.
        print("Login Successful");
        saveDetails(); /*Saving the details*/
        Utils.showToast("Login Successful");

        /*Moving to another HomeScreen*/
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
      } else if (modifiedBody.markers == ' no') {
        // If server returns an OK response, parse the JSON.
        Utils.showToast("Invalid Credentials");
      } else {
        // If that response was not OK, throw an error.
        Utils.showToast("Server Error");
        throw Exception('Failed to load post');
      }
    } else {
      Utils.showToast("Server Error");
    }
  }

  void correctJSON(String modifiedRequest) {
    /*This method adds \" in the response, because the response was not valid JSON*/
    modifiedRequest = StringUtils.addCharAtPosition(
        modifiedRequest, '\"', modifiedRequest.indexOf(':') + 1);
    modifiedRequest = StringUtils.addCharAtPosition(
        modifiedRequest, '\"', modifiedRequest.indexOf(','));
    modifiedRequest = StringUtils.addCharAtPosition(
        modifiedRequest, '\"', modifiedRequest.indexOf('}'));
    modifiedRequest = StringUtils.addCharAtPosition(
        modifiedRequest, '\"', modifiedRequest.lastIndexOf(':') + 1);
    modifiedBody = Login.fromJson(jsonDecode(modifiedRequest));
  }

  void saveDetails() {
    GroupsAndVehicles.IMEI = imei.toString();
    Utils.addStringPref(GroupsAndVehicles.IMEILabel, imei.toString());
    Utils.addStringPref(
        GroupsAndVehicles.loginStatusLabel, GroupsAndVehicles.loggedInStatus);
    Utils.addStringPref(
        GroupsAndVehicles.accountIDLabel, accountIdController.text);
    Utils.addStringPref(GroupsAndVehicles.userIDLabel, userIDController.text);
    Utils.addStringPref(
        GroupsAndVehicles.passwordLabel, passwordController.text);
    Utils.addStringPref(GroupsAndVehicles.mapTypeLabel, modifiedBody.maptype);
    GroupsAndVehicles.accountID = accountIdController.text;
    GroupsAndVehicles.userID = userIDController.text;
    GroupsAndVehicles.IMEI =
        Utils.getStringPref(GroupsAndVehicles.IMEILabel).toString();
    GroupsAndVehicles.mapType = modifiedBody.maptype;
    ; /*Get Value from Shared Preference*/
    GroupsAndVehicles.ipaddress =
        Utils.getStringPref(GroupsAndVehicles.ipAddressLabel)
            .toString(); /*Get Value from Shared Preference*/
  }
}
