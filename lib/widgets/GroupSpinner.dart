import 'package:flutter/material.dart';
import 'package:transportincharge_flutter/models/City.dart';
import 'package:transportincharge_flutter/utils/GroupsAndVehicles.dart';
import 'package:transportincharge_flutter/utils/Utils.dart';


class GroupSpinner extends StatefulWidget {
final List list;
final String type;
GroupSpinner(this.list, this.type);

  @override
  _GroupSpinnerState createState() => _GroupSpinnerState();
}

class _GroupSpinnerState extends State<GroupSpinner> {
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentValue;

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(10.0),child: Card(
      color: Colors.white,
      elevation: 6.0,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: EdgeInsets.only(top:2.0,bottom:2.0,left:6.0,right:6.0),
          child: DropdownButton(
            value: _currentValue,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
        ),
      ),
    ),);
  }

  void changedDropDownItem(String selectedValue) {
    Utils.addStringPref(widget.type, selectedValue);
    print("Selected Value : $selectedValue, UI refreshed");
    setState(() {
      _currentValue = selectedValue;
    });
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentValue= _dropDownMenuItems[0].value;
    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String item in widget.list) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: item,
          child: new Text(item)
      ));
    }
    return items;
  }
}



