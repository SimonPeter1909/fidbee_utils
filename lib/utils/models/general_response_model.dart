// To parse this JSON data, do
//
//     final generalResponseModel = generalResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../fidbee_utils.dart';

GeneralResponseModel generalResponseModelFromJson(String str) {
  try{
    return GeneralResponseModel.fromJson(json.decode(str));
  } catch (e){
    FidbeeUtils.logD('json decode error - $e');
    return null;
  }
}

String generalResponseModelToJson(GeneralResponseModel data) => json.encode(data.toJson());

class GeneralResponseModel {
  String response;
  String leadId;

  GeneralResponseModel({
    this.response,
    this.leadId
  });

  factory GeneralResponseModel.fromJson(Map<String, dynamic> json) => GeneralResponseModel(
    response: json["response"] == null ? null : json["response"],
    leadId: json["lead_id"] == null ? null : json["lead_id"],
  );

  Map<String, dynamic> toJson() => {
    "response": response == null ? null : response,
  };
}
