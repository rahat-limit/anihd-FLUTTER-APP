import 'package:anihd/view/screens/favourite_screen.dart';
import 'package:anihd/view/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenController extends StatelessWidget {
  const ScreenController({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: Colors.white70,
              tabs: [
                Tab(icon: Icon(CupertinoIcons.home)),
                Tab(icon: Icon(CupertinoIcons.heart)),
              ],
            ),
            centerTitle: false,
            title: const Text(
              'AniHD',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            // actions: [
            //   IconButton(
            //       splashRadius: 21,
            //       onPressed: () {},
            //       icon: const Icon(Icons.more_vert, size: 25))
            // ],
          ),
          body: const TabBarView(children: [HomeScreen(), FavouriteScreen()]),
        ));
  }
}
