/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_storage_service.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService{

  Future<SharedPreferences> getSharedPrefers() async{
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefers();
    switch(T){
      case int:
        return prefs.getInt(key) as T?;

      case String:
        return prefs.getString(key) as T?;
      
      default:
        throw UnimplementedError("Get not implemented for type ${T.runtimeType}");

    }
  }

  @override
  Future<bool> removeKey(String key)async {
    final prefs = await getSharedPrefers();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async  {
    final prefs = await getSharedPrefers();
    switch(T){
      case int:
        prefs.setInt(key, value as int);
      break;

      case String:
        prefs.setString(key, value as String);
      break;
      

      //Generic RunType
      default:
        throw UnimplementedError("Set not implemented for type ${T.runtimeType}");

    }
  }

}