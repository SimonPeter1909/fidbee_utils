import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:fidbee_utils/plugins_utils/SharedPreferences.dart';

import '../fidbee_utils.dart';

class AlertScreen extends StatefulWidget {
  final Color bgColor;
  AlertScreen({this.bgColor});
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.bgColor,
        title: Text('Alerts'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  // false = user must tap button, true = tap outside dialog
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      title: Text('Warning'),
                      content: Text('Do you Really want to Clear the List?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('No'),
                          onPressed: () async {
                            Navigator.of(dialogContext)
                                .pop(); // Dismiss alert dialog
                          },
                          color: Colors.green,
                        ),
                        FlatButton(
                          child: Text('Yes'),
                          onPressed: () async {
                            Navigator.of(dialogContext)
                                .pop(); // Dismiss alert dialog
                            await Preferences.clearAlertList();
                            setState(() {});
                            Fluttertoast.showToast(msg: 'Cleared');
                          },
                          color: Colors.red,
                        ),
                      ],
                    );
                  },
                );
              },
              textColor: Colors.white,
              child: Text('Clear All'))
        ],
      ),
      body: FutureBuilder<List<String>>(
          future: Preferences.getAlertList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              FidbeeUtils.logD('error - ${snapshot.error}');
              return Text('Error');
            }
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return Center(
                child: Text('No Alerts'),
              );
            }
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                shrinkWrap: true,
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    alertItem(snapshot.data[index]));
          }),
    );
  }

  Widget alertItem(String alertData) {
    FidbeeUtils.logD('alert data - $alertData');
    var mapData = json.decode(alertData);
//    try{
//      mapData = json.decode(alertData);
//    } catch (e) {
//      FidbeeUtils.print('decode error - $e');
//    }
    return ListTile(
      title: Text(mapData['body']),
      subtitle: Text(mapData['title']),
      trailing: Text(
        DateFormat('dd MMM, yy\nhh:mm aa')
            .format(DateTime.parse(mapData['date'])),
        textAlign: TextAlign.center,
      ),
    );
  }
}
