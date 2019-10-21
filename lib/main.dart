import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:transportincharge_flutter/screens/HomeScreen.dart';
import 'package:transportincharge_flutter/screens/LoginPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:transportincharge_flutter/utils/Utils.dart';

import 'anim/SlideAnimation.dart';

void main() {
  runApp(MaterialApp(
    home: TransportIncharge(),
    debugShowCheckedModeBanner: false,
  ));
}

class TransportIncharge extends StatefulWidget {
  @override
  _TransportInchargeState createState() => _TransportInchargeState();
}

class _TransportInchargeState extends State<TransportIncharge> {
  Permission permission;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(seconds: 2),
      () {

        Navigator.push(
          context,
          SlideAnimation(page: LoginPage()),
        );
      /*  bool val=await Utils.userLoggedIn();
        if (val==true) {
          Navigator.push(
            context,
            SlideAnimation(page: HomeScreen()),
          );
        }else{
          Navigator.push(
            context,
            SlideAnimation(page: LoginPage()),
          );
        }*/
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: <Widget>[
            FlutterLogo(
              size: 200.0,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SpinKitFadingCircle(
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
