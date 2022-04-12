import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  Future<void> writeSecureToken(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> readSecureToken(String key) async {
    return await storage.read(key: key);
  }

  Future<void> deleteSecureToken(String key) async {
    await storage.delete(key: key);
  }
}