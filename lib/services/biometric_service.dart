import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

/// Provides biometric authentication capabilities (Fingerprint/Face ID).
/// Uses `local_auth` package to verify the user identity locally on the device,
/// ensuring that sensitive financial data cannot be accessed by unauthorized users.
class BiometricService {
  static final _auth = LocalAuthentication();

  /// Checks if the device has biometric hardware and if any biometrics are enrolled.
  /// Returns [true] if the device supports biometric or device-level auth.
  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } on PlatformException {
      return false; // Hardware not found or permission denied
    }
  }

  /// Triggers the native OS biometric prompt.
  /// Returns [true] if authentication is successful or if biometrics are unavailable (graceful fallback).
  /// Returns [false] if the user fails authentication or cancels the prompt.
  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return true; // If device doesn't support biometrics, bypass

    try {
      // Prompts the user with system-level UI dialog
      return await _auth.authenticate(
        localizedReason: 'Scan your fingerprint (or face) to secure your financial data',
      );
    } on PlatformException {
      return false;
    }
  }
}
