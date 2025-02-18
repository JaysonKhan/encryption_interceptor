import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'aes_helper.dart';

class EncryptionInterceptor extends Interceptor {
  final AESHelper aesHelper;

  EncryptionInterceptor(this.aesHelper);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.data != null) {
      String encryptedData = aesHelper.encrypt(jsonEncode(options.data));
      log("Shifrlangan ma'lumot: $encryptedData");
      options.data = {"payload": encryptedData};
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data != null && response.data["payload"] != null) {
      String decryptedData = aesHelper.decrypt(response.data["payload"]);
      response.data = jsonDecode(decryptedData);
    }
    super.onResponse(response, handler);
  }
}


void main() {
  final aesHelper = AESHelper("KHAN347");

 final String encryptedText = aesHelper.encrypt("Hello, World!");
  print("Shifrlangan matn: $encryptedText");

  final String decryptedText = aesHelper.decrypt(encryptedText);
  print("Deshifrlangan matn: $decryptedText");
}