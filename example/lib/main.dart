import 'package:dio/dio.dart';
import 'package:encryption_interceptor/encryption_interceptor.dart';

void main() async {
  // Initialize Dio instance
  final dio = Dio();

  // Add EncryptionInterceptor with a secret key
  dio.interceptors.add(EncryptionInterceptor("my_super_secret_key"));

  try {
    // Sending an encrypted POST request
    Response response = await dio.post(
      "https://api.example.com/login",
      data: {"username": "test_user", "password": "securepassword"},
    );

    print("Decrypted Response: ${response.data}");
  } catch (e) {
    print("Request failed: $e");
  }

  try {
    // Sending an encrypted GET request (if enabled in interceptor)
    Response response = await dio.get("https://api.example.com/user/profile");

    print("Decrypted GET Response: ${response.data}");
  } catch (e) {
    print("GET request failed: $e");
  }
}
