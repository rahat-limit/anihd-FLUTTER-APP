import 'package:anihd/model/schemas/wallpaper.dart';
import 'package:anihd/view/screens/wallpaper_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CardWidget extends StatelessWidget {
  final Wallpaper wallpaper;
  const CardWidget({super.key, required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: wallpaper.path,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) {
        return Stack(children: [
          Container(
            margin: const EdgeInsets.all(3),
            // height: 320,
            height: SizerUtil.deviceType == DeviceType.tablet ? 600 : 320,
            decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10)),
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WallpaperScreen(wallpaper: wallpaper)));
              },
            ),
          )),
        ]);
      },
      placeholder: (context, url) => Container(
          margin: const EdgeInsets.all(4),
          height: 200,
          child: const Center(
              child: Image(
            image: AssetImage('assets/img/cache_image.png'),
          ))),
      errorWidget: (context, url, error) => const Image(
        image: AssetImage('assets/img/cache_image.png'),
      ),
    );
  }
}
