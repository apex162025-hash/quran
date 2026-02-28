import 'package:shared_preferences/shared_preferences.dart';
import '../enums/enums.dart';
import 'cache_helper.dart';

class CacheController {
  static final CacheController _instance = CacheController._internal();
  factory CacheController() => _instance;
  CacheController._internal();

  late SharedPreferences _shared;
  bool _cacheInitialized = false;

  Future<void> initSharedPreferences() async {
    _shared = await SharedPreferences.getInstance();
    _cacheInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_cacheInitialized) {
      await initSharedPreferences();
    }
  }

  Future<void> setter({required CacheKeys key, required dynamic value}) async {
    await _ensureInitialized();

    if (value is String) {
      if (key == CacheKeys.userToken) {
        await _shared.setString(key.name, 'Bearer $value');
      } else {
        await _shared.setString(key.name, value);
      }
    } else if (value is int) {
      await _shared.setInt(key.name, value);
    } else if (value is bool) {
      await _shared.setBool(key.name, value);
    }
  }

  dynamic getter({required CacheKeys key}) {
    if (!_cacheInitialized) return null;
    return _shared.get(key.name);
  }

  Future<void> logout({bool clearAll = true}) async {
    await _ensureInitialized();

    //  Save language settings before clearing
    final savedLangCode = _shared.getString('langCode');
    final savedCountryCode = _shared.getString('countryCode');

    if (clearAll) {
      await _shared.clear();
      await CacheHelper.clearAll();
    } else {
      await _shared.remove(CacheKeys.userToken.name);
      await _shared.remove(CacheKeys.userType.name);
    }

    //  Restore language settings after clearing
    if (savedLangCode != null) {
      await _shared.setString('langCode', savedLangCode);
    }
    if (savedCountryCode != null) {
      await _shared.setString('countryCode', savedCountryCode);
    }
  }

  static String get usertype =>
      CacheHelper.getData(key: CacheKeys.userType.name);
}
