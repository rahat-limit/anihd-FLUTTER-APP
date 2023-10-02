import 'package:anihd/model/schemas/wallpaper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Map<String, dynamic>? wallpaperSchema;

class LocalStorage {
  String nameBox = 'favourite_wallpapers';
  late Box box = Hive.box<Map<dynamic, dynamic>>(nameBox);

  initHiveBox() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);
    await Hive.openBox<Map<dynamic, dynamic>>(nameBox);
  }

  closeBox() async {
    await Hive.close();
  }

  getFromBox(String id) async {
    try {
      var data = await box.get(id);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  putInBox(Wallpaper wallpaper) async {
    try {
      await box.put(wallpaper.id, wallpaper.toJson());
    } catch (e) {
      rethrow;
    }
  }

  removeFromBox(String id) async {
    try {
      await box.delete(id);
    } catch (e) {
      rethrow;
    }
  }
}
