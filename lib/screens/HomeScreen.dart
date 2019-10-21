import 'package:flutter/material.dart';
import 'package:transportincharge_flutter/anim/SlideAnimation.dart';
import 'package:transportincharge_flutter/widgets/DrawerWidget.dart';

class HomeScreen extends StatelessWidget {
  /*Fetching Vechicle Group data from Network*/

  /* final response = await http.get(
  'http://track.glovision.co/callerlocation/login.php?accountID=Bhashyam&userID=admin&password=bhashyamadmin&imei=990000862471854&lat=$latitude&lng=$longitude&tokenid=0000&version=1');
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text("Map Here"),
      ),
      drawer: DrawerWidget(),
    );
  }
}
