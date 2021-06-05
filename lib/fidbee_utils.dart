library fidbee_utils;

import 'dart:io';

import 'package:animations/animations.dart';
import 'package:app_settings/app_settings.dart';
import 'package:autostart/autostart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:share/share.dart';
import 'package:fidbee_utils/plugins_utils/PackageInfo.dart';
import 'package:fidbee_utils/utils/models/master_model.dart';
import 'package:fidbee_utils/widgets/month_picker_strip.dart';

import './firebase/fb_auth/fb_auth.dart';
import './pages/alert_screen.dart';
import './pages/loading_screen.dart';
import './pages/login_screen/login_screen.dart';
import './pages/settings_screen/settings_screen.dart';
import './plugins_utils/CacheNetworkImages.dart';
import './plugins_utils/Fluttertoast.dart';
import './plugins_utils/ImagePicker.dart';
import './plugins_utils/SharedPreferences.dart';
import './plugins_utils/URLLauncher.dart';
import './plugins_utils/image_downloader.dart';
import './plugins_utils/parse_html.dart';
import './utils/base_url/check_base_url.dart';
import './utils/check_apk_version.dart';
import './utils/device_unlock.dart';
import './utils/navigator.dart';
import './utils/res.dart';
import './utils/restart_widget.dart';
import './widgets/bubble_tab_indicator.dart';
import './widgets/firebase_forget_password/firebase_forget_password.dart';
import './widgets/full_screen_image.dart';
import './widgets/pull_to_refresh.dart';
import 'utils/api/request.dart';

enum BaseURLState { LOCAL, ONLINE, FIREBASE }

class FidbeeUtils {
  /// sets the [header] key for api request
  static Future<bool> setHeader(String header) => Preferences.setHeader(header);

  /// send http request to the server and gets response as json encoded String
  /// if error - returns null
  static Future<String> request(
          {BuildContext context,
          @required String url,
          Map<String, String> body = const {}}) =>
      Request.request(context: context, url: url, body: body);

  /// check if the baseURL exists
  /// if not - set the baseURL as per the parameter and checks for https and http connections
  static Future<bool> checkBaseURL(
          {@required BaseURLState baseURLState,
          String onlineURL,
          String localURL}) =>
      CheckBaseURL.checkBaseURL(
          baseURLState: baseURLState, onlineURL: onlineURL, localURL: localURL);

  /// checks if the current build number matches the one in the server
  static Future<bool> checkApkVersion() => CheckAPKVersion.checkApkVersion();

  ///------------------COMMON WIDGETS-----------------------------------------
  /// a common widget for loading state
  /// needs the app logo asset [image] string
  static Widget loadingWidget({@required String image}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            image,
            height: 100,
          ),
          SizedBox(
            height: 20,
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  static verticalGap(double height) => SizedBox(
        height: height,
      );

  static horizontalGap(double width) => SizedBox(
        width: width,
      );

  static Widget successWidget(
      {@required String message, @required Function onDone}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
          SizedBox(
            height: 20,
          ),
          OutlineButton.icon(
              onPressed: () => onDone(),
              icon: Icon(Icons.thumb_up),
              label: Text(message))
        ],
      ),
    );
  }

  /// a common widget for error state
  /// needs a function to execute when user clicks [retry]
  static Widget errorWidget({@required BuildContext context}) {
    return Center(
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Something went Wrong'),
        content: Text('Sorry for the Inconvinence.'),
        actions: <Widget>[
          FlatButton(
            child: Text('Exit App'),
            onPressed: () => SystemNavigator.pop(),
          ),
          FlatButton(
              onPressed: () => restartApp(context: context),
              child: Text('Retry'))
        ],
      ),
    );
  }

  /// a common widget for showing Alert Dialog
  static Future showAlertDialog(
      {@required BuildContext context,
      bool barrierDismissible = false,
      @required Widget title,
      @required Widget content,
      @required List<Widget> actions(dialogContext)}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: title,
          content: content,
          actions: actions(dialogContext),
        );
      },
    );
  }

  /// a common widget for showing Alert Dialog
  static Future showBottomModalSheet({
    @required BuildContext context,
    bool barrierDismissible = false,
    bool enableDrag = true,
    bool isDismissible = true,
    @required Widget child(context),
  }) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: enableDrag,
        backgroundColor: Colors.white,
        isDismissible: isDismissible,
        shape: sheetTopRoundCorner(),
        builder: (BuildContext sheetContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              sheetTopDragWidget(),
              child(sheetContext),
            ],
          );
        });
  }

  /// Stream Builder Widget. Use to get values from firestore. this method changes the
  /// state from loading the widget
  static Widget commonStreamBuilderWidget(AsyncSnapshot<QuerySnapshot> snapshot,
      {@required successWidget(AsyncSnapshot<QuerySnapshot> snapshot)}) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasError) {
      FidbeeUtils.logE('snapshot error', error: snapshot.error);
      return Center(
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Something went Wrong'),
          content: Text('Sorry for the Inconvinence.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Exit App'),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      );
    } else {
      FidbeeUtils.logD('snapshot - ${snapshot.data.documents.length}');
      if (snapshot.data.documents.isEmpty) {
        return Center(
          child: Text('No Records Found'),
        );
      } else {
        return successWidget(snapshot);
      }
    }
  }

  ///gradient button
  static gradientButton(
      {bool isFullWidth = true,
      @required BorderRadius borderRadius,
      @required Gradient gradient,
      @required List<BoxShadow> boxShadow,
      @required Function onPressed,
      BoxShape buttonShape = BoxShape.rectangle,
      Function onLongPressed,
      @required EdgeInsets labelPadding,
      Color textColor = Colors.white,
      @required String label}) {
    return ConstrainedBox(
      constraints: isFullWidth
          ? BoxConstraints.tightFor(width: double.infinity)
          : BoxConstraints.tightForFinite(),
      child: Container(
        decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: buttonShape == BoxShape.circle ? null : borderRadius,
            boxShadow: boxShadow,
            shape: buttonShape),
        child: FlatButton(
            color: Colors.transparent,
            child: Padding(
              padding: labelPadding,
              child: Text(label),
            ),
            onLongPress: onLongPressed,
            textColor: textColor,
            onPressed: onPressed),
      ),
    );
  }

  ///this is an image widget, to display image from [url]
  ///pass the asset url for displaying [errorAssetImage]
  static Widget imageWidget(
          {@required String url,
          @required String errorAssetImage,
          double height,
          double width,
          BoxFit boxFit}) =>
      CacheNetworkImages().imageWidget(url, errorAssetImage,
          width: width, height: height, boxFit: boxFit);

  static Widget sigmaText({@required Color textColor}) => GestureDetector(
        onTap: () {
          launchURL('http://www.sigmacomputers.in');
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<String>(
                future: PackageInfoUtils.getAppVersion(),
                builder: (context, snapshot) {
                  return Text(
                    'App Version ${snapshot.data ?? ''}',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: textColor.withOpacity(.5)),
                  );
                }),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  Res.sigmaLogo,
                  height: 40,
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Powered By ',
                        style: TextStyle(
                            color: textColor.withOpacity(.5),
                            fontStyle: FontStyle.italic,
                            fontSize: 12)),
                    Text(
                      'Sigma,Salem',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontFamily: 'Font',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )
                  ],
                ),
                // RichText(
                //   text: TextSpan(
                //       text: 'Powered by ',
                //       style: TextStyle(
                //           color: textColor, fontStyle: FontStyle.italic),
                //       children: [
                //         TextSpan(
                //             text: 'SIGMA,Salem',
                //             style: TextStyle(
                //                 color: textColor,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 16))
                //       ]),
                // )
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      );

  static Widget settingsScreen(
      {@required Function(BuildContext context) changePassword,
      @required Function(BuildContext context) onLogout,
      bool themeEnabled = true,
      BuildContext context,
      bool multiLanguageEnabled = false,
      @required Function(BuildContext context, bool value) switchTheme,
      @required Function(BuildContext context) chooseLanguage}) {
    return SettingsScreen(
        themeEnabled: themeEnabled,
        context: context,
        multiLanguageEnabled: multiLanguageEnabled,
        switchTheme: (context, value) => switchTheme(value, context),
        chooseLanguage: (context) => chooseLanguage(context),
        onLogout: (context) => onLogout(context),
        changePassword: (context) => changePassword(context));
  }

  static Widget splashScreen(
          {@required String appName,
          Widget customBody,
          @required Widget logoImage,
          @required Widget errorScreen,
          @required Function userFound,
          @required Function userNotFound,
          @required Function lockNotFound,
          @required Future<bool> checkURL,
          @required String appURL,
          @required bool checkLock,
          @required BoxDecoration boxDecoration,
          @required bool firebaseAdmin,
          @required Color sigmaTextColor,
          @required bool showSigma}) =>
      LoadingScreen(
        checkURL: checkURL,
        appName: appName,
        logoImage: logoImage,
        customBody: customBody,
        errorScreen: errorScreen,
        userFound: userFound,
        userNotFound: userNotFound,
        lockNotFound: lockNotFound,
        checkLock: checkLock,
        appURL: appURL,
        sigmaTextColor: sigmaTextColor,
        bgDecoration: boxDecoration,
        firebaseAdmin: firebaseAdmin,
        showSigma: showSigma,
      );

  ///------------------COMMON WIDGETS ENDS------------------------------------

  ///---------------TOAST---------------------------------------------------
  static successToast(String message) => ToastUtils.successToast(message);

  static errorToast(String message) => ToastUtils.errorToast(message);

  static warningToast(String message) => ToastUtils.warningToast(message);

  ///---------------TOAST ENDS-------------------------------------------------

  ///---------------IMAGE & VIDEO PICKER---------------------------------------
  static Future<File> getImageFromGallery() =>
      ImagePickerUtils.imageFromGallery();

  static Future<File> getImageFromCamera() =>
      ImagePickerUtils.imageFromCamera();

  static Future<File> getVideoFromGallery() =>
      ImagePickerUtils.videoFromGallery();

  static Future<File> getVideoFromCamera() =>
      ImagePickerUtils.videoFromCamera();

  ///---------------IMAGE & VIDEO PICKER ENDS----------------------------------

  ///---------------URL LAUNCHER---------------------------------------
  static launchURL(String url) => UrlLauncherUtils.launchURL(url);

  static call(String number) => UrlLauncherUtils.launchURL('tel: $number');

  static email(String email) => UrlLauncherUtils.launchURL('mailto: $email');

  static Future launchSystemMap(
          {@required double lat, @required double long}) async =>
      await UrlLauncherUtils.launchSystemMap(lat, long);

  ///---------------URL LAUNCHER ENDS---------------------------------------

  ///-----------------SHARED PREFERENCES--------------------------------------
  static Future<bool> isLoggedIn() => Preferences.isLoggedIn();

  static Future<bool> setLoginStatus(bool status) =>
      Preferences.setLoginStatus(status);

  static Future<bool> isAdmin() => Preferences.isAdmin();

  static Future<bool> setAdminStatus(bool status) =>
      Preferences.setAdminStatus(status);

  static Future<bool> setFirstLaunch(bool status) =>
      Preferences.setFirstLaunch(status);

  static Future<bool> isFirstLaunch() => Preferences.isFirstLaunch();

  static Future<bool> saveUserId(String userName) =>
      Preferences.saveUserId(userName);

  static Future<String> getUserId() => Preferences.getUserId();

  static Future<bool> saveEmail(String email) => Preferences.saveEmail(email);

  static Future<String> getEmail() => Preferences.getEmail();

  static Future<bool> saveFirstName(String userName) =>
      Preferences.saveFirstName(userName);

  static Future<String> getFirstName() => Preferences.getFirstName();

  static Future<bool> saveToken(String userName) =>
      Preferences.saveToken(userName);

  static Future<String> getToken() => Preferences.getToken();

  static Future<bool> saveLastName(String userName) =>
      Preferences.saveLastName(userName);

  static Future<String> getLastName() => Preferences.getLastName();

  static Future<bool> savePhoneNumber(String userName) =>
      Preferences.savePhoneNumber(userName);

  static Future<String> getPhoneNumber() => Preferences.getPhoneNumber();

  static Future<bool> saveAvatar(String userName) =>
      Preferences.saveAvatar(userName);

  static Future<String> getPassword() => Preferences.getPassword();

  static Future<bool> savePassword(String password) =>
      Preferences.savePassword(password);

  static Future<String> getString({String key}) =>
      Preferences.getString(key: key);

  static Future<bool> saveString({String key, String value}) =>
      Preferences.saveString(key: key, value: value);

  static Future<String> getBool({String key}) => Preferences.getBool(key: key);

  static Future<bool> saveBool({String key, String value}) =>
      Preferences.saveBool(key: key, value: value);

  static Future<String> getAvatar() => Preferences.getAvatar();

  static Future<bool> logout() => Preferences.clearPreference();

  ///-----------------SHARED PREFERENCES ENDS----------------------------------

//  ///------------------Share on WhatsApp----------------------------------
//  static shareOnWhatsApp({
//    String number,
//    String message,
//    File file,
//  }) =>
//      Shareonwhatsapp()
//          .shareToWhatsApp(number: number, msg: message, file: file);
//
//  static shareOnWhatsAppBroadCast({
//    String message,
//    File file,
//  }) =>
//      Shareonwhatsapp().shareToWhatsApp(msg: message, file: file);

  ///------------------Share on WhatsApp End----------------------------------

  ///------------------OTHER UTILS---------------------------------------
  ///opens a full screen image widget with pinch zoom and rotate.
  ///needs [imageURL] as a mandatory Parameter
  static fullScreenImage(String imageURL, {ImageProvider imageProvider}) =>
      FullScreenImage(imageURL: imageURL, imageProvider: imageProvider);

  static RoundedRectangleBorder roundCorner(double radius) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  }

  static Container sheetTopDragWidget() => Container(
        margin: EdgeInsets.all(8),
        height: 5,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.grey),
      );

  static RoundedRectangleBorder sheetTopRoundCorner() => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)));

  ///Opens system share tray with  [message] as a mandatory Parameter
  static share(String message, {String subject}) =>
      Share.share(message, subject: subject);

  static parseHtmlAsString(String htmlString) =>
      ParseHtml.parseHtmlString(htmlString);

  static Future<File> downloadedImage(String imageURL) =>
      DownLoadImg.fileImage(imageURL);

  static bubbleTabBarIndicator(
          {double height = 20,
          Color tabColor,
          EdgeInsets insets = const EdgeInsets.symmetric(horizontal: 5.0),
          EdgeInsets padding =
              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          double radius = 100,
          TabBarIndicatorSize tabBarIndicatorSize}) =>
      BubbleTabIndicatorUtils.bubbleTabIndicator(
          insets, padding, height, radius, tabColor, tabBarIndicatorSize);

  ///------------------OTHER UTILS ENDS------------------------------------

  ///------------------Navigator------------------
//  static setOffline(bool offline) => Preferences.setOffline(offline);

  static DateTime currentBackPressTime;

  static Future<bool> onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ToastUtils.warningToast('Press Again to Exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  static Future<dynamic> push(
          {@required BuildContext context,
          @required Widget toWidget,
          PageTransitionType transitionType = PageTransitionType.fade,
          bool isOffline = false}) =>
      MyNavigator().push(
          context: context,
          toWidget: toWidget,
          isOffline: isOffline,
          transitionType: transitionType);

  static Future<dynamic> pushReplacement(
          {@required BuildContext context,
          @required Widget toWidget,
          PageTransitionType transitionType = PageTransitionType.fade,
          bool isOffline = false}) =>
      MyNavigator().pushReplacement(
          context: context,
          toWidget: toWidget,
          isOffline: isOffline,
          transitionType: transitionType);

  ///------------------Navigator Ends------------------

  static restartWidget({@required Widget myApp}) => RestartWidget(
        child: myApp,
      );

  static restartApp({@required BuildContext context}) async {
    // await Preferences.clearBaseURL();
    RestartWidget.restartApp(context);
  }

  ///------------------Pull To Refresh --------------------
  static Widget pullToRefresh(
      {@required Function refresh,
      @required Widget child,
      RefreshController refreshController}) {
    if (refreshController == null)
      refreshController = RefreshController(initialRefresh: false);
    return PullToRefresh(refreshController)
        .listView(listViewBuilder: child, refresh: refresh);
  }

  static refreshCompleted({RefreshController refreshController}) {
    if (refreshController == null)
      refreshController = RefreshController(initialRefresh: false);
    return PullToRefresh(refreshController).onRefreshComplete();
  }

  ///------------------Pull To Refresh ENDS--------------------

  ///------------ Notifications -----------------------
  static Future<dynamic> openAlertScreen(BuildContext context) async {
    return await push(context: context, toWidget: AlertScreen());
  }

  static Future<List<String>> getAlerts() async {
    return await Preferences.getAlertList();
  }

  static saveAlerts(String alert) async {
    await Preferences.addToAlertList(alert);
  }

  ///------------ Notifications Ends-----------------------

  ///--------------Firebase Auth---------------------------
  static Future<bool> firebaseLoginWithEmail(
          {String email, String password}) async =>
      await FBAuth().login(email, password);

  static Future<bool> firebaseLoginWithCredentials(
          AuthCredential credential) async =>
      await FBAuth().loginWithCredentials(credential);

  static Future<bool> firebaseRegisterWithEmail(
          {String email, String password}) async =>
      await FBAuth().register(email, password);

  static Future<bool> firebaseIsLoggedIn() async => await FBAuth().isLoggedIn();

  static Future<bool> firebaseSendPasswordResetLink({String email}) async =>
      await FBAuth().sendPasswordResetLink(email);

  static Future<String> firebaseCurrentUID() async =>
      await FBAuth().currentUid();

  static firebaseLogout() async => await FBAuth().logout();

  static firebaseSendOTPCode({
    @required String phoneNumber,
    @required PhoneVerificationCompleted verificationCompleted,
    @required PhoneVerificationFailed verificationFailed,
    @required PhoneCodeSent codeSent,
    @required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    @required Duration timeOut,
  }) async =>
      await FBAuth().sendOtpCode(
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          verificationCompleted: verificationCompleted,
          timeOut: timeOut,
          phoneNumber: phoneNumber);

  static Future<bool> firebaseSignInWithOTP(
          {@required String otp, @required String verificationId}) async =>
      await FBAuth().signInWithOTP(verificationId: verificationId, otp: otp);

  static firebaseForgetPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return FirebaseForgetPassword();
      },
    );
  }

  static firebaseLoginScreen(
          {@required String appIcon,
          @required Function(BuildContext context) onSuccess,
          @required Function(BuildContext context) onFail}) =>
      FirebaseLoginScreen(
          appLogo: appIcon,
          onSuccess: (context) => onSuccess(context),
          onFail: (context) => onFail(context));

  ///---------------------Firebase Auth ENDS------------------------

  static Future<UnlockDeviceStatus> deviceUnlock() async {
    return UnlockDevice.unlockDevice();
  }

  ///enable notification permission
  static checkNotificationPermission(BuildContext context) async {
    bool isAutoStartPermissionAvailable =
        await Autostart.isAutoStartPermissionAvailable;
    if (isAutoStartPermissionAvailable) {
      FidbeeUtils.logD('test available ok');
      // Autostart.getAutoStartPermission();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                'This Device Needs Permission to Get Pop-UP Notifications'),
            content: Text(
                'Please Enable AutoStart. And Enable All Functions in the Notification'),
            actions: [
              FlatButton(
                  onPressed: () async => await AppSettings.openAppSettings(),
                  child: Text('Open App Settings'))
            ],
          ),);
      // await AppSettings.openSecuritySettings();
    } else {
      FidbeeUtils.logD('test available fail');
      ToastUtils.warningToast(
          'This Device Doesn\'t need Notification Permission');
    }
  }

  ///use this for all print();
  ///this method prints all the response
  static Logger logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printTime: true,
      printEmojis: true,
    ),
  );

  static logD(String message) => logger.d(message);

  static logE(String message, {@required dynamic error}) =>
      logger.e(message, error);

  ///------------------------------Masters---------------------------------

  static Future updateMaster(
      {@required String tableName,
      @required String id,
      @required String nameValue,
      Map<String, String> additionalFields}) async {
    String userId = await FidbeeUtils.getUserId();

    if (userId == null || userId.isEmpty) {
      logD('user id is not fount in session');
      return null;
    }

    Map<String, String> body = {
      'table_name': tableName,
      'id': id,
      'ref_user_id': userId,
      'name_value': nameValue,
    };

    logD('body - $body');

    if (additionalFields != null) body.addAll(additionalFields);

    return masterModelFromJson(
        await FidbeeUtils.request(url: 'update_master', body: body));
  }

  static Future deleteMaster(
      {@required String tableName, @required String id}) async {
    String userId = await FidbeeUtils.getUserId();

    if (userId == null || userId.isEmpty) {
      logD('user id is not fount in session');
      return null;
    }

    Map<String, String> body = {
      'table_name': tableName,
      'id': id,
      'ref_user_id': userId,
    };

    return masterModelFromJson(
        await FidbeeUtils.request(url: 'delete_master', body: body));
  }

  ///--------------------Animations-----------------
  static Widget openTransition({
    @required Widget fromWidget(Function onTap),
    @required Widget toWidget,
    double fromWidgetElevation,
    Duration transitionDuration = const Duration(milliseconds: 500),
    ShapeBorder fromWidgetShape,
    Color fromWidgetColor,
    ClosedCallback onBack,
  }) {
    return OpenContainer(
      closedElevation: fromWidgetElevation,
      transitionType: ContainerTransitionType.fade,
      transitionDuration: transitionDuration,
      closedShape: fromWidgetShape,
      closedColor: fromWidgetColor,
      onClosed: (data) => onBack != null ? onBack(data) : () {},
      closedBuilder: (context, action) => fromWidget(action),
      openBuilder: (context, action) => toWidget,
    );
  }

  static Widget fabTransition({
    @required Widget icon,
    @required Widget toWidget,
    double fabElevation = 6.0,
    double fabDimension = 56.0,
    Duration transitionDuration = const Duration(milliseconds: 500),
    Color fabColor,
    ClosedCallback onBack,
  }) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return toWidget;
      },
      openColor: fabColor,
      closedElevation: fabElevation,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(fabDimension / 2),
        ),
      ),
      onClosed: (data) => onBack != null ? onBack(data) : () {},
      closedColor: fabColor,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
          height: fabDimension,
          width: fabDimension,
          child: Center(
            child: icon,
          ),
        );
      },
    );
  }

  ///---------- responsive builder -----------------
  static responsiveBuilder(BuildContext context, Widget child) {
    return ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, child),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
        background: Container(color: Color(0xFFF5F5F5)));
  }
}
