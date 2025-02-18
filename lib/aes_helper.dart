import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class AESHelper {
  final Key key;
  final IV iv;

  AESHelper(String secretKey)
      : key = Key.fromUtf8(secretKey.padRight(32, 'x')),
        // 32-byte key
        iv = IV.fromLength(16); // 16-byte IV

  /// So‘rov ma’lumotlarini shifrlaydi
  String encrypt(String text) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return base64Encode(encrypted.bytes);
  }

  /// Javob ma’lumotlarini deshifrlaydi
  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}
