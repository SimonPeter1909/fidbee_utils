import 'package:package_info/package_info.dart';
import 'package:fidbee_utils/utils/api/request.dart';
import 'package:fidbee_utils/utils/models/general_response_model.dart';

class CheckAPKVersion {
  static Future<bool> checkApkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    GeneralResponseModel model =
        await getApkVersion({'apk_version': packageInfo.buildNumber});
    if (model == null || model.response == '0') {
      return false;
    } else {
      return true;
    }
  }

  static Future<GeneralResponseModel> getApkVersion(Map<String, String> body) async {
    return generalResponseModelFromJson(
        await Request.request(url: 'check_apk_version', body: body));
  }
}
