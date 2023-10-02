import 'package:anihd/model/services/local_storage.dart';
import 'package:anihd/view/screen_controller.dart';
import 'package:anihd/view_model/wallpaper_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    await LocalStorage().initHiveBox();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WallpaperViewModel())
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.deepPurple[600],
              appBarTheme: const AppBarTheme(
                  color: Colors.deepPurple,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light))),
          debugShowCheckedModeBanner: false,
          home: const ScreenController(),
        );
      }),
    ));
  });
}
