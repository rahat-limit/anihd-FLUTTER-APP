import 'package:anihd/model/schemas/wallpaper.dart';
import 'package:anihd/view/widgets/card.dart';
import 'package:anihd/view_model/wallpaper_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:once/once.dart';
import 'package:provider/provider.dart';

class ListWallpapers extends StatefulWidget {
  const ListWallpapers({super.key});

  @override
  State<ListWallpapers> createState() => _ListWallpapersState();
}

const String key = 'update';

class _ListWallpapersState extends State<ListWallpapers> {
  final _scrollController = ScrollController();
  WallpaperViewModel? _data;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _data = Provider.of<WallpaperViewModel>(context);
    await _data!.getInitWallpaper();
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future _onScroll() async {
    if (_isBottom) {
      await Once.runCustom(key, callback: () {
        _data!.addWallpapers(1);
      }, duration: const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Consumer<WallpaperViewModel>(builder: (context, data, _) {
              final category = _data!.getCategory;
              List<Wallpaper> wallpapers;

              switch (category) {
                case Category.girls:
                  wallpapers = data.getGirlishWallpapers;
                  break;
                case Category.aesthetic:
                  wallpapers = data.getAestheticWallpapers;
                  break;
                case Category.random:
                  wallpapers = data.getRandomWallpapers;
                  break;
                case Category.title:
                  wallpapers = data.getTitled;
                  break;
                case Category.blackAndWhite:
                  wallpapers = data.getBlackAndWhite;
                  break;
                default:
                  wallpapers = data.getWallpapers;
                  break;
              }
              return MasonryGridView.builder(
                  cacheExtent: 9999,
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: wallpapers.length + 1,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  itemBuilder: (context, item) {
                    if (item == wallpapers.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CardWidget(wallpaper: wallpapers[item]);
                  });
            })));
  }
}
