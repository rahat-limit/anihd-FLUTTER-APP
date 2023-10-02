import 'dart:io';
import 'dart:math';
import 'package:anihd/model/schemas/wallpaper.dart';
import 'package:anihd/model/services/admob.dart';
import 'package:anihd/model/wallpaper_repository.dart';
import 'package:anihd/view/widgets/action_button.dart';
import 'package:anihd/view_model/wallpaper_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

const double bannerHeight = 70;

class WallpaperScreen extends StatefulWidget {
  final Wallpaper wallpaper;
  const WallpaperScreen({super.key, required this.wallpaper});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  BannerAd? _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  bool _isAwardedAdLoaded = false;
  bool _adPermission = false;
  RewardedAd? _rewardedAd;
  bool _loading = false;

  void loadAd() {
    RewardedAd.load(
        adUnitId: AdHelper.awardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
            setState(() {
              _isAwardedAdLoaded = true;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd!.load();
  }

  Future<void> _showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // <-- SEE HERE
            title: const Text('Set Wallpaper'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();

                  await set(WallpaperPosition.home);
                },
                child: const Text('Home Screen'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await set(WallpaperPosition.lock);
                },
                child: const Text('Lock Screen'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await set(WallpaperPosition.both);
                },
                child: const Text('Both Screens'),
              ),
            ],
          );
        });
  }

  Future download() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() {
      _loading = true;
    });
    bool? result = await GallerySaver.saveImage(widget.wallpaper.path);

    if (result == null || !result) {
      setState(() {
        _loading = false;
      });
      return scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Something went wrong:(',
              style: TextStyle(color: Colors.orange))));
    }
    setState(() {
      _loading = false;
    });
    return scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text('Wallpaper successfully setted!',
            style: TextStyle(color: Colors.orange))));
  }

  Future set(WallpaperPosition position) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    WallpaperRepository repository = WallpaperRepository();
    setState(() {
      _loading = true;
    });
    bool status = await repository.setWallpaper(
        widget.wallpaper.path, widget.wallpaper.id, position);
    setState(() {
      _loading = false;
    });
    if (status) {
      return scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Wallpaper successfully setted',
              style: TextStyle(color: Colors.orange))));
    } else {
      return scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Wallpaper Failed',
              style: TextStyle(color: Colors.orange))));
    }
  }

  // ------------------------------------------------------------Ads
  Future<bool> perfomVideoAd() async {
    // return true;
    bool randomBoolean = Random().nextBool();
    if (randomBoolean) {
      if (_rewardedAd != null) {
        _rewardedAd!.dispose();
      }
      return true;
    }
    if (_isAwardedAdLoaded && !_adPermission) {
      await _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {});
      _adPermission = true;
      return true;
    } else {
      return _adPermission;
    }
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
    // ------------------------------------------------------------Ads
    loadAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd!.dispose();
    // ------------------------------------------------------------Ads
    if (_rewardedAd != null) {
      _rewardedAd!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await perfomVideoAd();
      },
      child: Scaffold(
          body: Stack(alignment: Alignment.bottomCenter, children: [
        CachedNetworkImage(
            imageUrl: widget.wallpaper.path,
            progressIndicatorBuilder: (context, url, progress) =>
                const CircularProgressIndicator(),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity),
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Consumer<WallpaperViewModel>(
                      builder: (context, provider, child) {
                    void like() {
                      provider.toggleLike(widget.wallpaper);
                    }

                    bool isLiked = provider.getWallpapers.firstWhere(
                        (item) => item == widget.wallpaper, orElse: () {
                      return Wallpaper(path: '', category: Category.aesthetic);
                    }).liked;
                    return ActionButton(
                        icon: Icons.favorite_outline,
                        callback: like,
                        isLiked: isLiked);
                  }),
                  ActionButton(
                    icon: Icons.share,
                    callback: () async {
                      await Provider.of<WallpaperViewModel>(context,
                              listen: false)
                          .shareAnImage(widget.wallpaper.path);
                    },
                  ),
                  Platform.isAndroid
                      ? ActionButton(icon: Icons.download, callback: download)
                      : const SizedBox(),
                  Platform.isAndroid
                      ? ActionButton(
                          icon: Icons.download_done,
                          callback: _showSimpleDialog)
                      : ActionButton(icon: Icons.download, callback: download)
                ]),
                _isBottomBannerAdLoaded
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: _bottomBannerAd!.size.height.toDouble(),
                        width: _bottomBannerAd!.size.width.toDouble(),
                        child: AdWidget(ad: _bottomBannerAd!),
                      )
                    : const SizedBox()
              ],
            )),
        Positioned(
            top: 50,
            left: 20,
            child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () async {
                  await perfomVideoAd().then((value) {
                    if (value) {
                      Navigator.pop(context);
                    } else {
                      return;
                    }
                  });
                })),
        _loading
            ? Positioned(
                child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              ))
            : const SizedBox(),
      ])),
    );
  }
}
