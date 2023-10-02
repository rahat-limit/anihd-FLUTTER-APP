import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum Category { girls, aesthetic, title, blackAndWhite, random }

Category defineCategory(int value) {
  switch (value) {
    case 0:
      return Category.girls;
    case 1:
      return Category.aesthetic;
    case 2:
      return Category.title;
    case 3:
      return Category.blackAndWhite;
    case 4:
      return Category.random;
    default:
      return Category.aesthetic;
  }
}

var uuid = const Uuid();

class Wallpaper extends Equatable {
  final String id;
  final String path;
  final Category category;
  final bool liked;
  Wallpaper(
      {String? id, required this.path, required this.category, bool? liked})
      : id = id ?? uuid.v4(),
        liked = liked ?? false;

  Wallpaper copyWith(bool? like) {
    return Wallpaper(
        id: id, path: path, category: category, liked: like ?? liked);
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "path": path, "category": category.index, "liked": liked};

  factory Wallpaper.fromJson(Map<dynamic, dynamic> json) => Wallpaper(
      id: json['id'] ?? uuid.v4(),
      path: json['path'] as String,
      category: defineCategory(json['category'] as int),
      liked: json['liked'] ?? false);
  @override
  List<Object> get props => [id];
}
