import 'package:flutter/material.dart';
import 'package:scaler/widget/drawer_widget.dart';


class EditLogPage extends StatefulWidget {
  @override
  _EditLogPageState createState() => _EditLogPageState();
}

class _EditLogPageState extends State<EditLogPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans'),
      ),
      body: Center(
        child: Text('data')
      ),
    );
  }
}
