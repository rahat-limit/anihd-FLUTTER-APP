import 'dart:io';
import 'package:anihd/model/services/local_storage.dart';
import 'package:anihd/model/services/wallpaper_api.dart';
import 'package:anihd/model/schemas/wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class WallpaperViewModel with ChangeNotifier {
  Category _category = Category.aesthetic;
  final List<Wallpaper> _wallpapers = [];
  int imagesPerPage = 5;
  final List<Map<String, dynamic>> _categories = [
    {
      "title": "Aesthetic",
      "tumbler": "aesthetic_tumb.webp",
      "category": Category.aesthetic
    },
    {
      "title": "Girls",
      "tumbler": "girls_tumb.webp",
      "category": Category.girls
    },
    {"title": "Title", "tumbler": "titled.jpg", "category": Category.title},
    {
      "title": "Black And White",
      "tumbler": "black_white.jpg",
      "category": Category.blackAndWhite
    },
    {"title": "Random", "tumbler": "random.jpg", "category": Category.random},
  ];

  Category get getCategory => _category;
  List<Wallpaper> get getWallpapers => _wallpapers;
  List<Map<String, dynamic>> get getCategories => _categories;
  List<Wallpaper> get getAestheticWallpapers =>
      _wallpapers.where((item) => item.category == Category.aesthetic).toList();
  List<Wallpaper> get getGirlishWallpapers =>
      _wallpapers.where((item) => item.category == Category.girls).toList();
  List<Wallpaper> get getTitled =>
      _wallpapers.where((item) => item.category == Category.title).toList();
  List<Wallpaper> get getBlackAndWhite => _wallpapers
      .where((item) => item.category == Category.blackAndWhite)
      .toList();
  List<Wallpaper> get getLikedWallpapers =>
      _wallpapers.where((item) => item.liked).toList();
  List<Wallpaper> get getRandomWallpapers =>
      _wallpapers.where((item) => item.category == Category.random).toList();

  int definePage(List<Wallpaper> items) {
    return items.length ~/ imagesPerPage + 1;
  }

  List<Wallpaper> defineWallpapersByCategory() {
    switch (_category) {
      case Category.aesthetic:
        return getAestheticWallpapers;
      case Category.girls:
        return getGirlishWallpapers;
      case Category.random:
        return getWallpapers;
      case Category.title:
        return getTitled;
      case Category.blackAndWhite:
        return getBlackAndWhite;
      default:
        return getAestheticWallpapers;
    }
  }

  Future getInitWallpaper() async {
    WallpaperApi api = WallpaperApi();

    List<Wallpaper> list = await api.getWallpaper(
        imagesPerPage: imagesPerPage,
        pageNumber: definePage(defineWallpapersByCategory()),
        category: _category);
    _wallpapers.addAll(list);
  }

  Future addWallpapers(int num) async {
    WallpaperApi api = WallpaperApi();

    List<Wallpaper> list = await api.getWallpaper(
        imagesPerPage: imagesPerPage,
        pageNumber: definePage(defineWallpapersByCategory()),
        category: _category);
    _wallpapers.addAll(list);
    notifyListeners();
  }

  void changeCategory(Category newCategory) {
    _category = newCategory;
    notifyListeners();
  }

  void toggleLike(Wallpaper wallpaper) async {
    for (int i = 0; i < _wallpapers.length; i++) {
      if (_wallpapers[i] == wallpaper) {
        LocalStorage localStorage = LocalStorage();
        if (_wallpapers[i].liked) {
          // delete from local storage
          await localStorage.removeFromBox(_wallpapers[i].id);
        } else {
          // save to local storage
          await localStorage.putInBox(wallpaper);
        }
        Wallpaper newWallpaper = Wallpaper(
            id: _wallpapers[i].id,
            path: _wallpapers[i].path,
            category: _wallpapers[i].category,
            liked: !_wallpapers[i].liked);
        _wallpapers.remove(_wallpapers[i]);
        _wallpapers.insert(i, newWallpaper);
      }
    }
    notifyListeners();
  }

  Future shareAnImage(String path) async {
    try {
      var temp = await getApplicationDocumentsDirectory();
      String imageName = path.split('showImage?src=').last;
      String tempPath = '${temp.path}/$imageName';
      var response = await http.get(Uri.parse(path));
      if (response.statusCode != 200) {
        return;
      }
      File newFile = await File(tempPath).create(recursive: true);
      newFile.writeAsBytesSync(response.bodyBytes);
      await Share.shareXFiles([XFile(newFile.path)],
          text: 'AniHd Anime Wallpaper',
          sharePositionOrigin: Rect.fromCenter(
              center: const Offset(100, 100), width: 100, height: 100));
    } catch (e) {
      rethrow;
    }
  }
}
