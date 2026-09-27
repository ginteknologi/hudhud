import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/models/user_model.dart';
import 'package:masjid_app/providers/api_providers.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AsyncValue.loading()) {
    checkAuthStatus();
  }

  void checkAuthStatus() {
    try {
      final isLogin = PreferencesService.isLogin;
      final userJson = PreferencesService.userJson;
      if (isLogin && userJson != null) {
        final Map<String, dynamic> map = jsonDecode(userJson);
        state = AsyncValue.data(UserModel.fromJson(map));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loginGoogle() async {
    state = const AsyncValue.loading();
    try {
      final google = GoogleSignIn.instance;
      await google.initialize();
      final account = await google.authenticate();

      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post<UserModel>(
        ApiEndpoints.profile,
        data: {
          'name': account.displayName ?? 'Pengguna Google',
          'email': account.email,
          'photo': account.photoUrl ?? '',
        },
        fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      final user = response.data ??
          UserModel(
            id: 1,
            name: account.displayName ?? 'Pengguna Google',
            email: account.email,
            photo: account.photoUrl ?? '',
          );

      PreferencesService.isLogin = true;
      PreferencesService.userJson = jsonEncode(user.toJson());
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loginGuest() async {
    state = const AsyncValue.loading();
    try {
      final guest = UserModel(
        id: 0,
        name: 'Tamu (Guest)',
        email: 'guest@hudhud.app',
        photo: '',
      );
      PreferencesService.isLogin = true;
      PreferencesService.userJson = jsonEncode(guest.toJson());
      state = AsyncValue.data(guest);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    await PreferencesService.clearAuth();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});
