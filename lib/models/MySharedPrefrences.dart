import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {

  static SharedPreferences? _prefs;
  static const _keyCreate = 'create';

  static Future<SharedPreferences> init() async =>
      _prefs = await SharedPreferences.getInstance();

  static Future setCreate(bool create) async =>
      await _prefs!.setBool(_keyCreate, create);

  static bool getCreate() => _prefs!.getBool(_keyCreate) ?? true;

  static const _keyFirstTime = 'firstTime';

  static Future setFirstTime(bool firstTime) async =>
      await _prefs!.setBool(_keyFirstTime, firstTime);

  static bool getFirstTime() => _prefs!.getBool(_keyFirstTime) ?? true;


  static const _keyLogin = 'type';

  static Future setType(String login) async => await _prefs!.setString(_keyLogin, login);

  static String getType() => _prefs!.getString(_keyLogin) ?? "al" ;
    
  

}
