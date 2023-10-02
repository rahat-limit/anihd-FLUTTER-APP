import 'package:anihd/model/schemas/wallpaper.dart';
import 'package:anihd/model/services/local_storage.dart';
import 'package:anihd/view/widgets/card.dart';
import 'package:anihd/view/widgets/headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 20),
      ValueListenableBuilder(
          valueListenable: LocalStorage().box.listenable(),
          builder: (context, value, child) {
            return value.isNotEmpty
                ? const HeadlineWidget(title: 'favourite')
                : const SizedBox();
          }),
      const SizedBox(height: 10),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ValueListenableBuilder(
                  valueListenable: LocalStorage().box.listenable(),
                  builder: (context, data, _) {
                    if (data.isEmpty) {
                      return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                image: AssetImage('assets/img/box.png'),
                                width: 150,
                                height: 150),
                            SizedBox(height: 15),
                            Text(
                              'Empty',
                              style: TextStyle(
                                  fontFamily: 'Londrina',
                                  letterSpacing: 1,
                                  color: Colors.white,
                                  fontSize: 32),
                            ),
                            SizedBox(height: 30)
                          ]);
                    }
                    if (!data.isOpen) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return MasonryGridView.builder(
                        cacheExtent: 9999,
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: data.values.length,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          Wallpaper wallpaper = Wallpaper.fromJson(
                              data.getAt(data.values.length - 1 - index));
                          return CardWidget(wallpaper: wallpaper);
                        });
                  })))
    ]);
  }
}
