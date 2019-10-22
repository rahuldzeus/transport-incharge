import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportincharge_flutter/anim/SlideAnimation.dart';
import 'package:transportincharge_flutter/models/City.dart';
import 'package:transportincharge_flutter/utils/Utils.dart';
import 'package:transportincharge_flutter/widgets/DrawerWidget.dart';
import 'package:transportincharge_flutter/widgets/GroupSpinner.dart';

class HomeScreen extends StatelessWidget {
  /*Fetching Vechicle Group data from Network*/

  /* final response = await http.get(
  'http://track.glovision.co/callerlocation/login.php?accountID=Bhashyam&userID=admin&password=bhashyamadmin&imei=990000862471854&lat=$latitude&lng=$longitude&tokenid=0000&version=1');
*/
  @override
  Widget build(BuildContext context) {
    List<String> list = [
      "Cluj-Napoca",
      "Bucuresti",
      "Timisoara",
      "Brasov",
      "Constanta"
    ];
    var city = City(list, "city");
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            /*add a map here*/
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GroupSpinner(list, "CITY"),
                      ),
                      Expanded(
                        flex: 1,
                        child: GroupSpinner(list, "CITY"),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Card(color: Colors.redAccent,child: Container(height:60,padding: EdgeInsets.all(20.0),),),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(color: Colors.purple,child: Container(height:60,padding: EdgeInsets.all(20.0),),),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(color: Colors.greenAccent,child: Container(height:60,padding: EdgeInsets.all(20.0),),),
                      ),
                    ],
                  ),
                ],),
              )
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(onPressed: () {
                        var dialog= await _asyncSelectionDialog(context);
                      },backgroundColor: Colors.greenAccent,child: Icon(Icons.map),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(onPressed: () async {

                      },backgroundColor: Colors.purple,child: Icon(Icons.battery_alert),),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }



  Future<String> _asyncSelectionDialog(BuildContext context) async {
    String issue= '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Map type'),
          content: Column(children: <Widget>[
            Text('Satellite Map'),
            Text('Terrian Map'),

          ],),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {

                Navigator.of(context).pop(issue);
              },
            ),
          ],
        );
      },
    );
  }
}
