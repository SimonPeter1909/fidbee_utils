// To parse this JSON data, do
//
//     final masterModel = masterModelFromJson(jsonString);

import 'dart:convert';

import 'package:fidbee_utils/fidbee_utils.dart';

MasterModel masterModelFromJson(String str) {
  try{
    return MasterModel.fromJson(json.decode(str));
  } catch (e) {
    FidbeeUtils.logD('json decode error - $e');
    return null;
  }
}

String masterModelToJson(MasterModel data) => json.encode(data.toJson());

class MasterModel {

  MasterModel({
    this.response,
  });

  String response;

  factory MasterModel.fromJson(Map<String, dynamic> json) => MasterModel(
    response: json["response"] == null ? null : json["response"],
  );

  Map<String, dynamic> toJson() => {
    "response": response == null ? null : response,
  };
}
