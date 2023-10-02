import 'package:anihd/model/schemas/wallpaper.dart';
import 'package:anihd/view_model/wallpaper_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CategoryWidget extends StatelessWidget {
  final String title;
  final String path;
  final Category category;
  const CategoryWidget(
      {super.key,
      required this.title,
      required this.path,
      required this.category});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    WallpaperViewModel _data = Provider.of<WallpaperViewModel>(context);
    void changeCategory() {
      final initCategory = _data.getCategory;
      if (initCategory == category) return;
      _data.changeCategory(category);
    }

    return Stack(
      children: [
        Positioned(
          child: Container(
              width: SizerUtil.deviceType == DeviceType.tablet ? 220 : 190,
              height: SizerUtil.deviceType == DeviceType.tablet ? 200 : 130,
              margin: const EdgeInsets.only(
                left: 10,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    scale: 30,
                    image: AssetImage(path),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topLeft,
                  ))),
        ),
        Positioned(
          bottom: 15,
          left: 25,
          child: Text(
            title,
            style: const TextStyle(
                fontFamily: 'Londrina',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
                letterSpacing: 2),
          ),
        ),
        Positioned.fill(
            child: Container(
          margin: const EdgeInsets.only(left: 10),
          child: Material(
              color: Colors.transparent, child: InkWell(onTap: changeCategory)),
        )),
      ],
    );
  }
}
