import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/config/theme_data.dart';
import 'package:scaler/widget/simple_round_button.dart';

class AddItem extends StatefulWidget {
  AddItem();

  AddItemState createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Text('1'),
//                color: Colors.cyanAccent,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SimpleRoundButton(
                backgroundColor: TD.td.accentColor,
                textColor: Colors.white,
                buttonText: Text("SUBMIT"),
                onPressed: () {
                  print(TD.td.accentColor);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}