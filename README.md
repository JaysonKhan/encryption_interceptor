# encryption_interceptor

`encryption_interceptor` is a Dio interceptor that automatically **encrypts outgoing requests** and **decrypts incoming responses** using AES encryption. This ensures secure communication between the client and the server, even without HTTPS.

## 🚀 Features
✅ **AES Encryption (256-bit)** – Protects request and response data  
✅ **Automatic Request Encryption** – Encrypts request bodies before sending  
✅ **Automatic Response Decryption** – Decrypts responses before passing to the app  
✅ **Optional GET Request Encryption** – Choose whether to encrypt GET requests  
✅ **Skip Encryption for Specific Requests** – Use a custom header (`skip-encryption`)  
✅ **Lightweight & Easy to Use** – Plug-and-play with **Dio**

---

## 📦 Installation
Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  encryption_interceptor: ^1.0.0
```

Or install via CLI:

```sh
flutter pub add encryption_interceptor
```

---

## 🔧 Usage

### **1️⃣ Add the Interceptor to Dio**
```dart
import 'package:dio/dio.dart';
import 'package:encryption_interceptor/encryption_interceptor.dart';

void main() {
  final dio = Dio();

  // Add the interceptor with encryption enabled for all requests
  dio.interceptors.add(EncryptionInterceptor("my_super_secret_key"));

  // Making an encrypted request
  dio.post("https://api.example.com/login", data: {
    "username": "test",
    "password": "securepassword"
  });
}
```

---

### **2️⃣ Enabling GET Request Encryption**
By default, GET requests are **not encrypted** because they typically don’t have a body.  
If your API requires encrypted GET requests, enable it:

```dart
dio.interceptors.add(EncryptionInterceptor("my_secret_key", enableGetEncryption: true));
```

---

### **3️⃣ Skipping Encryption for Specific Requests**
If you need to send a plain request without encryption, use the `"skip-encryption"` header:

```dart
dio.post(
  "https://api.example.com/data",
  data: {"public_info": "This should not be encrypted"},
  options: Options(headers: {"skip-encryption": true}),
);
```

---

## 🛠 How It Works
1️⃣ **Before Sending a Request**
- The request body is encrypted using **AES 256-bit encryption**
- The encrypted data is sent as:
  ```json
  {
    "payload": "ENCRYPTED_DATA_HERE"
  }
  ```

2️⃣ **When Receiving a Response**
- The interceptor **automatically decrypts** the response body
- The decrypted JSON is **returned to the app in its original format**

---

## 🛡 Security Notes
- **AES encryption ensures high-level security**, but it is always recommended to use **HTTPS** alongside it.
- **Do not expose the secret key** in your frontend applications.
- **Ensure your server can decrypt AES-encoded data** before implementing this interceptor.

---

## 📜 License
This package is released under the MIT License.

---

## 💬 Need Help?
For any issues or feature requests, feel free to open an issue on GitHub.

