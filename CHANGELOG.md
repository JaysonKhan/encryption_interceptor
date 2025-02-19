## **📌 CHANGELOG.md**
```md
# Changelog

## [1.0.0] - Initial Release 🚀

### Added
- AES encryption for request bodies (AES-256 CBC mode)
- AES decryption for response bodies
- Support for GET request encryption (optional via `enableGetEncryption`)
- Ability to skip encryption for specific requests using `skip-encryption` header
- Automatic error handling for failed decryption
- Dio interceptor integration
- Optimized request encryption to prevent unnecessary re-encryption
- Improved error handling for cases where decryption fails
- Better performance when handling large response data
