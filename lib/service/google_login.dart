// lib/service/google_login.dart
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, debugPrint;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin {
  static const String _webClientId =
      '317872716423-3nt2oka3tl5f13lpupekarsaqr0jakod.apps.googleusercontent.com';

  static bool _initialized = false;

  static Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(
      clientId: kIsWeb ? _webClientId : null,
      // serverClientId hanya untuk non-Web (Android/iOS)
      serverClientId: kIsWeb ? null : _webClientId,
    );
    _initialized = true;
  }

  Future<Map<String, dynamic>> googleSignIn() async {
    await _ensureInitialized();
    final signIn = GoogleSignIn.instance;

    final completer = Completer<GoogleSignInAccount?>();
    late final StreamSubscription<GoogleSignInAuthenticationEvent> sub;

    sub = signIn.authenticationEvents.listen(
      (event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          if (!completer.isCompleted) completer.complete(event.user);
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          if (!completer.isCompleted) completer.complete(null);
        }
      },
      onError: (e, st) {
        if (!completer.isCompleted) completer.completeError(e, st);
      },
    );

    try {
      if (signIn.supportsAuthenticate()) {
        await signIn.authenticate();
      } else {
        await signIn.attemptLightweightAuthentication();
      }

      final user = await completer.future
          .timeout(const Duration(seconds: 30), onTimeout: () => null);

      if (user == null) {
        return {
          "code": 499,
          "message": "Login dibatalkan atau tidak tersedia.",
          "data": {}
        };
      }

      String? idToken;
      try {
        final auth = user.authentication;
        idToken = auth.idToken;
      } catch (_) {}

      return {
        "code": 200,
        "message": "Login berhasil.",
        "data": {
          "id": user.id,
          "name": user.displayName,
          "email": user.email,
          "photo": user.photoUrl,
          "idToken": idToken,
        }
      };
    } on GoogleSignInException catch (e) {
      return {
        "code": 500,
        "message": 'GoogleSignInException ${e.code}: ${e.description}',
        "data": {}
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Google Sign In Error: $e");
      }
      return {"code": 500, "message": "Login gagal: $e", "data": {}};
    } finally {
      await sub.cancel();
    }
  }

  Future<Map<String, dynamic>> googleSignOut() async {
    try {
      await GoogleSignIn.instance.disconnect();
      return {"code": 200, "message": "Anda berhasil keluar."};
    } catch (e) {
      return {"code": 500, "message": "Gagal keluar: $e"};
    }
  }
}
