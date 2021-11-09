import 'package:core_app/core_app.dart' show DrawerItem, kDavysGrey, kGrey;
import 'package:about/about.dart' show AboutPage;
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_show_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/home_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const ROUTE_NAME = '/home';

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(builder: (ctx, data, child) {
      final activeDrawerItem = data.selectedDrawerItem;

      return Scaffold(
        key: _drawerKey,
        drawer: _buildDrawer(ctx, (DrawerItem newSelectedItem) {
          data.setSelectedDrawerItem(newSelectedItem);
        }, activeDrawerItem),
        appBar: _buildAppBar(ctx, activeDrawerItem),
        body: _buildBody(ctx, activeDrawerItem),
      );
    });
  }

  Widget _buildBody(BuildContext context, DrawerItem seletedDrawerItem) {
    if (seletedDrawerItem == DrawerItem.movie) {
      return HomeMoviePage();
    } else if (seletedDrawerItem == DrawerItem.tvShow) {
      return HomeTVShowPage();
    }
    return Container();
  }

  AppBar _buildAppBar(
    BuildContext context,
    DrawerItem activeDrawerItem,
  ) =>
      AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SearchPage.ROUTE_NAME,
                arguments: activeDrawerItem,
              );
            },
            icon: Icon(Icons.search),
          )
        ],
      );

  Drawer _buildDrawer(
    BuildContext context,
    Function(DrawerItem) itemCallback,
    DrawerItem activeDrawerItem,
  ) =>
      Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              tileColor:
                  activeDrawerItem == DrawerItem.movie ? kDavysGrey : kGrey,
              leading: Icon(Icons.movie_creation_outlined),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
                itemCallback(DrawerItem.movie);
              },
            ),
            ListTile(
              tileColor:
                  activeDrawerItem == DrawerItem.tvShow ? kDavysGrey : kGrey,
              leading: Icon(Icons.live_tv_rounded),
              title: Text('TV Shows'),
              onTap: () {
                Navigator.pop(context);
                itemCallback(DrawerItem.tvShow);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      );
}
