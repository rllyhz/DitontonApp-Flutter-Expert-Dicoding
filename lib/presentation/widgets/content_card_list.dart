import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/drawer_item_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';

class ContentCardList extends StatelessWidget {
  final Movie? movie;
  final TVShow? tvShow;
  final DrawerItem activeDrawerItem;

  const ContentCardList({
    required this.activeDrawerItem,
    this.movie,
    this.tvShow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            MovieDetailPage.ROUTE_NAME,
            arguments: _getId(),
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle() ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    SizedBox(height: 16),
                    Text(
                      _getOverview() ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: "$BASE_IMAGE_URL${_getPosterPath()}",
                  width: 80,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getId() => activeDrawerItem == DrawerItem.Movie
      ? movie?.id as int
      : tvShow?.id as int;

  String? _getTitle() =>
      activeDrawerItem == DrawerItem.Movie ? movie?.title : tvShow?.name;

  String _getPosterPath() => activeDrawerItem == DrawerItem.Movie
      ? movie?.posterPath as String
      : tvShow?.posterPath as String;

  String? _getOverview() =>
      activeDrawerItem == DrawerItem.Movie ? movie?.overview : tvShow?.overview;
}
