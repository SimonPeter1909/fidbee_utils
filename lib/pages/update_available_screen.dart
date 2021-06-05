import 'package:flutter/material.dart';

import '../fidbee_utils.dart';

class UpdateAvailableScreen extends StatefulWidget {
  final Image appImage;
  final String appName;
  final String appLink;

  UpdateAvailableScreen({@required this.appImage,
    @required this.appLink,
    @required this.appName});

  @override
  _UpdateAvailableScreenState createState() => _UpdateAvailableScreenState();
}

class _UpdateAvailableScreenState extends State<UpdateAvailableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: widget.appImage,
                  title: Text(
                    '${widget.appName} needs an update',
                    // style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text(
                    'To use this app, download the latest version',
                    // style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: RaisedButton(
                    onPressed: () {
                      FidbeeUtils.launchURL(widget.appLink);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text('UPDATE'),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FidbeeUtils.sigmaText(textColor: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
