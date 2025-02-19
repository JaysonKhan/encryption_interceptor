import 'dart:convert';

import 'package:dio/dio.dart';

import 'aes_helper.dart';

/// **EncryptionInterceptor**
///
/// This interceptor encrypts request data and decrypts response data automatically
/// using AES encryption, ensuring secure communication.
///
/// 📌 **Key Features:**
/// - Encrypts request body before sending to the server.
/// - Decrypts response body received from the server.
/// - Protects against **Man-in-the-Middle attacks**.
/// - Works even **without HTTPS**.
/// - Skips encryption if the request body is empty or already encrypted.
/// - Supports optional skipping using a header (`skip-encryption: true`).
/// - **New:** Supports GET request encryption if `enableGetEncryption = true`.
class EncryptionInterceptor extends Interceptor {
  final String secretKey;
  final AESHelper _aesHelper;
  final bool
      enableGetEncryption; // Enables GET request encryption (default: false)

  /// **Constructor**
  /// - `secretKey`: AES encryption key
  /// - `enableGetEncryption`: If true, encrypts GET requests (default: false)
  EncryptionInterceptor(this.secretKey, {this.enableGetEncryption = false})
      : _aesHelper = AESHelper(secretKey);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // If GET encryption is disabled, skip GET requests encryption
    if (options.method == "GET" && !enableGetEncryption) {
      super.onRequest(options, handler);
      return;
    }

    // Check if encryption should be skipped via header
    if (options.headers["skip-encryption"] == true) {
      options.headers
          .remove("skip-encryption"); // Remove header after processing
      super.onRequest(options, handler);
      return;
    }

    // Ensure request has a body and is not already encrypted
    if (options.data != null && options.data is Map<String, dynamic>) {
      final Map<String, dynamic> requestData = options.data;

      if (!requestData.containsKey("payload")) {
        String encryptedData = _aesHelper.encrypt(jsonEncode(requestData));
        options.data = {"payload": encryptedData};
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data != null && response.data is Map<String, dynamic>) {
      final Map<String, dynamic> responseData = response.data;

      // Ensure response contains encrypted payload before decrypting
      if (responseData.containsKey("payload")) {
        try {
          String decryptedData = _aesHelper.decrypt(responseData["payload"]);
          response.data = jsonDecode(decryptedData);
        } catch (e) {
          print("Decryption failed: $e"); // Log the decryption error
          response.data = {"error": "Failed to decrypt response"};
        }
      }
    }
    super.onResponse(response, handler);
  }
}
