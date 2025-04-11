import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionHelper {
  static const _keyStorageKey = 'my_secure_key';
  static final _secureStorage = FlutterSecureStorage();

  static Future<encrypt.Key> _getKey() async {
    String? base64Key = await _secureStorage.read(key: _keyStorageKey);
    if (base64Key == null) {
      final key = List<int>.generate(32, (_) => Random.secure().nextInt(256));
      base64Key = base64UrlEncode(key);
      await _secureStorage.write(key: _keyStorageKey, value: base64Key);
    }
    return encrypt.Key.fromBase64(base64Key);
  }

  static Future<String> encryptText(String plainText) async {
    final key = await _getKey();
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static Future<String> decryptText(String encryptedText) async {
    final key = await _getKey();
    final parts = encryptedText.split(':');
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encryptedData = encrypt.Encrypted.fromBase64(parts[1]);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt(encryptedData, iv: iv);
  }
}
