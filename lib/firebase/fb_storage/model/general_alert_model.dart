import 'package:cloud_firestore/cloud_firestore.dart';

import '../fields.dart';

class GeneralAlertModel{
  String alert;
  DateTime alertDateTime;


  GeneralAlertModel({this.alert, this.alertDateTime});

  GeneralAlertModel fromSnapshot(DocumentSnapshot snapshot){
    return GeneralAlertModel(
        alert : snapshot.get(Fields.alert),
        alertDateTime : (snapshot.get(Fields.alert_date_time) as Timestamp).toDate()
    );
  }

  Map<String,dynamic> toMap(GeneralAlertModel model){
    return {
      Fields.alert : model.alert,
      Fields.alert_date_time : model.alertDateTime
    };
  }

}