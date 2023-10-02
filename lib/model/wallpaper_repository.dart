import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

enum WallpaperPosition { home, lock, both }

class WallpaperRepository {
  Future downloadWithPermission(String url, String id) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Format of Image
      String format = url.split('.').last;

      // Create an image name
      var filename = '${dir.path}/$id.$format';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        return 'Image saved to disk';
      }
    } catch (e) {
      return 'An error occurred while saving the image';
    }
  }

  Future downloadWallpaper(String url) async {
    try {
      // Saved with this method.
      var file = await DefaultCacheManager().getSingleFile(url);
      return file;
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  setWallpaper(String url, String id, WallpaperPosition position) async {
    try {
      int location;
      if (position == WallpaperPosition.home) {
        location = WallpaperManager.HOME_SCREEN;
      } else if (position == WallpaperPosition.lock) {
        location = WallpaperManager.LOCK_SCREEN;
      } else {
        location = WallpaperManager.BOTH_SCREEN;
      }

      var file = await downloadWallpaper(url);
      bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      return result;
    } on FormatException catch (_) {
      return false;
    }
  }
}
