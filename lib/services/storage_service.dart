import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final storage = const FlutterSecureStorage();
  StorageService();

// Read value
  Future<String?> get(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

// Read all values
  Future<Map<String, String>?> getAllValues() async {
    var value = await storage.readAll();
    return value;
  }

// Delete value
  deleteValue(String key) async {
    await storage.delete(key: key);
  }

  deleteAll() async {
    await storage.deleteAll();
  }
// Delete all

  set(String key, dynamic value) async {
    await storage.write(key: key, value: value.toString());
  }
// Write value
}
