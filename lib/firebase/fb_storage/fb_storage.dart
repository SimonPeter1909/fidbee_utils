import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fidbee_utils/plugins_utils/PackageInfo.dart';
import 'collections.dart';
import 'fields.dart';
import 'model/general_alert_model.dart';


class FirebaseStorage {
  final _storage = Firestore.instance;

  Future<String> getAdminSettingValue(String fields) async {
    DocumentSnapshot ds = await _storage
        .collection(Collections.adminSettings)
        .doc(fields)
        .get();
    return ds.get(fields);
  }

  Stream getAdminSettings() {
    return _storage.collection(Collections.adminSettings).snapshots();
  }

  Future saveAdminSettings(String key, String value) async {
    await _storage
        .collection(Collections.adminSettings)
        .document(key)
        .updateData({key: value});
  }

  Future<bool> addGeneralAlert(GeneralAlertModel model) async {
    return _storage
        .collection(Collections.generalAlert)
        .add(GeneralAlertModel().toMap(model))
        .then((value) => true)
        .catchError((e) => false);
  }

  Stream getAlertList() {
    return _storage
        .collection(Collections.generalAlert)
        .orderBy(Fields.alert_date_time, descending: true)
        .snapshots();
  }

  Future<bool> checkLockDate() async {
    DocumentSnapshot ds = await _storage
        .collection(Collections.lockDate)
        .document(Fields.lock_date)
        .get();
    DateTime lockDate = (ds.get(Fields.lock_date) as Timestamp).toDate();
    lockDate = DateTime(lockDate.year, lockDate.month, lockDate.day);
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    return lockDate.isAtSameMomentAs(now);
  }

  Future<bool> checkAPKVersion() async {
    return await getAdminSettingValue(Fields.apk_version) ==
        await PackageInfoUtils.getBuildNumber();
  }
}
