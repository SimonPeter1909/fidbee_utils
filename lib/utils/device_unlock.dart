import 'package:device_unlock/device_unlock.dart';

enum UnlockDeviceStatus { SUCCESS, FAILURE, NO_LOCK }

class UnlockDevice {
  static Future<UnlockDeviceStatus> unlockDevice() async {
    try {
      if (await DeviceUnlock()
          .request(localizedReason: "We need to check your identity.")) {
        // Unlocked successfully.
        return UnlockDeviceStatus.SUCCESS;
      } else {
        // Did not pass face, touch or pin validation.
        return UnlockDeviceStatus.FAILURE;
      }
    } on RequestInProgress {
      // A new request was sent before the first one finishes
      return UnlockDeviceStatus.NO_LOCK;
    } on DeviceUnlockUnavailable {
      // Device does not have face, touch or pin security available.
      return UnlockDeviceStatus.NO_LOCK;
    }
  }
}
