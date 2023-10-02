import 'dart:io';

import 'package:anihd/env/env.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // Production
      return Env.androidBannerId;
      // return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      // Production
      return Env.iosBannerId;
      // return "ca-app-pub-3940256099942544/2934735716";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get awardedAdUnitId {
    if (Platform.isAndroid) {
      // return Env.androidVideoAwardId;
      print(
          '${Env.androidVideoAwardId} kdjnwajkdnwadkjwandjwandkjanwdkjnawkdnawkjn----------------------------------------------------------------');
      // return "ca-app-pub-3940256099942544/5224354917";
      return 'ca-app-pub-7114356792970424/2689653268'; //between pages 2
    } else if (Platform.isIOS) {
      // return Env.iosVideoAwardId;
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  // static String get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-3940256099942544/1033173712";
  //   } else if (Platform.isIOS) {
  //     return "ca-app-pub-3940256099942544/4411468910";
  //   } else {
  //     throw UnsupportedError("Unsupported platform");
  //   }
  // }
}
