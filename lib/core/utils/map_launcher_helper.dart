import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncherHelper {
  /// Membuka rute navigasi di Google Maps atau aplikasi peta default
  static Future<void> openMapDirection({
    required double destinationLat,
    required double destinationLng,
    required String destinationName,
  }) async {
    // 1. Coba Google Maps Universal Web/App Intent
    final encodedName = Uri.encodeComponent(destinationName);
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=driving',
    );

    try {
      if (Platform.isAndroid) {
        final geoIntent = Uri.parse(
          'geo:$destinationLat,$destinationLng?q=$destinationLat,$destinationLng($encodedName)',
        );
        if (await canLaunchUrl(geoIntent)) {
          await launchUrl(geoIntent, mode: LaunchMode.externalApplication);
          return;
        }
      }

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        return;
      }

      // Fallback untuk browser biasa
      await launchUrl(googleMapsUrl, mode: LaunchMode.platformDefault);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Tidak dapat membuka Google Maps');
    }
  }
}
