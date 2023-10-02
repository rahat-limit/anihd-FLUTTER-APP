import 'dart:convert';
import 'package:anihd/env/env.dart';
import 'package:anihd/model/schemas/wallpaper.dart';
import 'package:anihd/model/services/local_storage.dart';
import 'package:hive/hive.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

const String _uri = Env.apiUri;
const String _girlyEndPoint = 'girly';
const String _keyImage = '/showImage?src=';
const String _aestheticEndPoint = 'aesthetic';
const String _titledEndPoint = 'titled';
const String _blackAndWhiteEndPoint = 'black_white';
const String _randomEndPoint = 'random';
const String sep = '///sep///';
const String getImages = '/get_images';

class WallpaperApi {
  getWallpaper(
      {required int imagesPerPage,
      required int pageNumber,
      required Category category}) async {
    try {
      String type = '';
      switch (category) {
        case Category.random:
          type = _randomEndPoint;
        case Category.aesthetic:
          type = _aestheticEndPoint;
        case Category.girls:
          type = _girlyEndPoint;
        case Category.title:
          type = _titledEndPoint;
        case Category.blackAndWhite:
          type = _blackAndWhiteEndPoint;
        default:
          type = _randomEndPoint;
      }
      final response = await http.get(Uri.parse(type == _randomEndPoint
          ? '$_uri/getRandom?n=$imagesPerPage&p=$pageNumber'
          : '$_uri$getImages?n=$imagesPerPage&p=$pageNumber&type_=$type'));
      print(type == _randomEndPoint
          ? '$_uri/getRandom?n=$imagesPerPage&p=$pageNumber'
          : '$_uri$getImages?n=$imagesPerPage&p=$pageNumber&type_=$type');
      List<Wallpaper> wallpapers = [];
      // If no images left???
      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body) as List<dynamic>;
      Box likedWallpapersBox = LocalStorage().box;
      Iterable<String> likedInfoList = likedWallpapersBox
          .toMap()
          .values
          .map((e) => '${e['id']}$sep${e['path']}');
      for (int i = 0; i < data.length; i++) {
        final imagePath = '$_uri$_keyImage${data[i]}';
        List<String> idOrPath = likedInfoList.toString().split(sep);
        Wallpaper wallpaper = Wallpaper(
            id: idOrPath.last.contains(imagePath) ? idOrPath.first : null,
            path: imagePath,
            category: category,
            liked: idOrPath.last.contains(imagePath) ? true : false);
        wallpapers.add(wallpaper);
      }
      return wallpapers;
    } catch (e) {
      rethrow;
    }
  }
}
