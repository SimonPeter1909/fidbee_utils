import 'dart:io';

import 'package:app_settings/app_settings.dart';
// import 'package:cross_connectivity/cross_connectivity.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// class MyNavigator {
//   Future<dynamic> push(
//       {@required BuildContext context,
//       @required Widget toWidget,
//       @required PageTransitionType transitionType,
//       @required bool isOffline}) async {
//     return await Navigator.push(
//         context,
//         PageTransition(
//             child: isOffline
//                 ? toWidget
//                 : ConnectivityBuilder(builder: (context, isConnected, status) {
//                   print('status - $status');
//                     switch (status) {
//                       case ConnectivityStatus.wifi:
//                         return toWidget;
//                         break;
//                       case ConnectivityStatus.mobile:
//                         return toWidget;
//                         break;
//                       case ConnectivityStatus.none:
//                         return offlineBanner(context);
//                         break;
//                       case ConnectivityStatus.ethernet:
//                         return toWidget;
//                         break;
//                       case ConnectivityStatus.unknown:
//                         return toWidget;
//                         break;
//                       default:
//                         return toWidget;
//                     }
//                   }),
//             type: transitionType));
//   }
//
//   Future<dynamic> pushReplacement(
//       {@required BuildContext context,
//       @required Widget toWidget,
//       @required PageTransitionType transitionType,
//       @required bool isOffline}) async {
//     return await Navigator.pushReplacement(
//         context,
//         PageTransition(
//             child: isOffline
//                 ? toWidget
//                 : ConnectivityBuilder(builder: (context, isConnected, status) {
//               print('status - $status');
//                     switch (status) {
//                       case ConnectivityStatus.wifi:
//                         return toWidget;
//                         break;
//                       case ConnectivityStatus.mobile:
//                         return toWidget;
//                         break;
//                       case ConnectivityStatus.none:
//                         return offlineBanner(context);
//                         break;
//                       case ConnectivityStatus.ethernet:
//                         return toWidget;
//                         break;
//                       case ConnectivityStatus.unknown:
//                         return toWidget;
//                         break;
//                       default:
//                         return toWidget;
//                     }
//                   }),
//             type: transitionType));
//   }
//
//   offlineBanner(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       color: Colors.white,
//       child: Center(
//         child: AlertDialog(
//           title: Text('No Internet'),
//           content: Text('Please check you Wi-Fi or Mobile Data'),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           actions: <Widget>[
//             FlatButton(
//                 onPressed: () async {
//                   await AppSettings.openDataRoamingSettings();
//                 },
//                 textColor: Colors.green,
//                 child: Text('Mobile Data')),
//             FlatButton(
//                 onPressed: () async {
//                   await AppSettings.openWIFISettings();
//                 },
//                 textColor: Colors.blue,
//                 child: Text('Wi-Fi')),
//           ],
//         ),
//       ),
//     );
//   }
// }


class MyNavigator {
  Future<dynamic> push(
      {@required BuildContext context,
        @required Widget toWidget,
        @required PageTransitionType transitionType,
        @required bool isOffline}) async {
    return await Navigator.push(
        context,
        PageTransition(
            child: toWidget,
            type: transitionType));
  }

  Future<dynamic> pushReplacement(
      {@required BuildContext context,
        @required Widget toWidget,
        @required PageTransitionType transitionType,
        @required bool isOffline}) async {
    return await Navigator.pushReplacement(
        context,
        PageTransition(
            child: toWidget,
            type: transitionType));
  }

  offlineBanner(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: AlertDialog(
          title: Text('No Internet'),
          content: Text('Please check you Wi-Fi or Mobile Data'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  await AppSettings.openDataRoamingSettings();
                },
                textColor: Colors.green,
                child: Text('Mobile Data')),
            FlatButton(
                onPressed: () async {
                  await AppSettings.openWIFISettings();
                },
                textColor: Colors.blue,
                child: Text('Wi-Fi')),
          ],
        ),
      ),
    );
  }
}
