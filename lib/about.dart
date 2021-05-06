import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              " \n  \n devloped   by   N   K   P \n\n\n",
              style: TextStyle(color: Colors.blueGrey),
            ),
            InkWell(
                child: new Text(
                  'Twitter',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () => launch('https://twitter.com/nishi19442443')),
          ],
        )),
      ),
    );
  }
}
