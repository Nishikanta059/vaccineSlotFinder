import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text('about'),
      ),
      body: Container(
        child: Center(
            child: Text(
          " \n  \n devloped   by   N   K   P",
          style: TextStyle(color: Colors.blueGrey),
        )),
      ),
    );
  }
}
