import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{
  final FlutterSecureStorage storage = FlutterSecureStorage();

  writeName(String key, String value) async{
    await storage.write(key:key,value:value);
  }

  writePassword(String key, String value) async{
    await storage.write(key:key,value:value);
  }

  Future<String?> readName(String key) async{
    return await storage.read(key:key);
  }

  Future<String?> readPassword(String key) async{
    return await storage.read(key:key);
  }

  Future<void> deleteName(String key) async{
    await storage.delete(key:key);
  }

  Future<void> deletePassword(String key) async{
    await storage.delete(key:key);
  }

  writeLoggedIn(String key, String value) async{
    await storage.write(key: key, value: value);
  }

  readLoggedIn(String key) async{
    String? value = await storage.read(key: key);

    if(value == null) {
      return "false";
    }
    else{
      return value;
    }
    }
}

