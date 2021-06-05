import 'dart:io';
import 'package:url_launcher/url_launcher.dart';


class UrlLauncherUtils {
	static void launchURL(String url) async {
		if (await canLaunch(url)) {
			await launch(url);
		} else {
			throw 'Could not launch $url';
		}
	}

	static Future launchSystemMap(double lat, double lng) async {
		var mapLuanchUrl;
		if (Platform.isAndroid) {
			mapLuanchUrl =
			"https://www.google.com/maps/search/?api=1&query=" + lat.toString() + "," + lng.toString();
		} else if (Platform.isIOS) {
			mapLuanchUrl = 'https://maps.apple.com/?q='  + lat.toString() + "," + lng.toString();
		}
		if (await canLaunch(mapLuanchUrl)) {
			await launch(mapLuanchUrl);
		} else {
			throw 'Could not launch ' + mapLuanchUrl;
		}
	}
}