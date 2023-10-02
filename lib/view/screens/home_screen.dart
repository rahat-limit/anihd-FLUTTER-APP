import 'package:anihd/view/widgets/category.dart';
import 'package:anihd/view/widgets/headline.dart';
import 'package:anihd/view/widgets/list_wallpapers.dart';
import 'package:anihd/view_model/wallpaper_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    WallpaperViewModel _data = Provider.of<WallpaperViewModel>(context);
    final categories = _data.getCategories;
    return Column(
      children: [
        const SizedBox(height: 20),
        const HeadlineWidget(title: 'featured'),
        const SizedBox(height: 10),
        SizedBox(
          height: SizerUtil.deviceType == DeviceType.tablet ? 200 : 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryWidget(
                  title: categories[index]['title'].toString(),
                  path: 'assets/img/${categories[index]['tumbler']}',
                  category: categories[index]['category']);
            },
          ),
        ),
        const SizedBox(height: 20),
        const ListWallpapers()
      ],
    );
  }
}
