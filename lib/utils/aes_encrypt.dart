import 'package:encrypt/encrypt.dart';
import 'dart:typed_data';
import 'package:flutter_devices_sdk/log/log_printer.dart';

class AesEncrypt {
  // 你的密钥和初始化向量（IV）
  static final Uint8List _keyBytes =
      Uint8List.fromList('xczvbnmawsdetfgyhujikolpq208914i'.codeUnits.toList());
  static final Uint8List _iv =
      Uint8List.fromList('0000000000000000'.codeUnits.toList());
  // AES加密
  static String aesEncrypt(String plainText) {
    final key = Key(_keyBytes);
// 创建加密器
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    try {
      final iv = IV(_iv);
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base64; // 返回Base64编码的加密字符串
    } catch (e) {
      // 处理加密错误
      LogPrinter.log("AES encryption error: $e");
      rethrow; // 或者返回一个错误消息/默认值
    }
  }

  // AES解密
  static String aesDecrypt(String encryptedText) {
    final key = Key(_keyBytes);
// 创建加密器
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    try {
      final iv = IV(_iv);
      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
      return decrypted; // 返回解密后的字符串
    } catch (e) {
      // 处理解密错误
      LogPrinter.log("AES decryption error: $e");
      rethrow; // 或者返回一个错误消息/默认值
    }
  }
}
