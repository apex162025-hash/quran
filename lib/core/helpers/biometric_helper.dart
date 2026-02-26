import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Wraps [LocalAuthentication] for biometric operations.
class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if biometric authentication is available on this device.
  Future<bool> canUseBiometric() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      log('Error checking biometrics: $e');
      return false;
    }
  }

  /// Check if the device supports device authentication.
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      log('Error checking device support: $e');
      return false;
    }
  }

  /// Get available biometric types.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      log('Error getting biometrics: $e');
      return [];
    }
  }

  /// Trigger biometric authentication prompt.
  Future<bool> authenticate({
    required String reason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      log('Authentication error: $e');
      return false;
    }
  }
}
