import 'package:core_app/core_app.dart'
    show
        GenreModel,
        SeasonModel,
        TVShow,
        TVShowDetailResponse,
        TVShowModel,
        TVShowResponse,
        TVShowTable;

const testTVShowModel = TVShowModel(
  backdropPath: "/oC9SgtJTDCEpWnTBtVGoAvjl5hb.jpg",
  firstAirDate: "2006-09-18",
  genreIds: [10767],
  id: 1991,
  name: "Rachael Ray",
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Rachael Ray",
  overview:
      "Rachael Ray, also known as The Rachael Ray Show, is an American talk show starring Rachael Ray that debuted in syndication in the United States and Canada on September 18, 2006. It is filmed at Chelsea Television Studios in New York City. The show's 8th season premiered on September 9, 2013, and became the last Harpo show in syndication to switch to HD with a revamped studio. In January 2012, CBS Television Distribution announced a two-year renewal for the show, taking it through the 2013–14 season.",
  popularity: 1765.863,
  posterPath: "/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg",
  voteAverage: 5.8,
  voteCount: 29,
);

final testTVShowModelList = <TVShowModel>[testTVShowModel];

final testTVShow = testTVShowModel.toEntity();

final testTVShowList = <TVShow>[testTVShow];

final testTVShowResponse = TVShowResponse(tvShowList: testTVShowModelList);

const testTVShowDetailResponse = TVShowDetailResponse(
  backdropPath: '',
  firstAirDate: '',
  genres: [GenreModel(id: 1, name: 'Action')],
  id: 2,
  episodeRunTime: [],
  homepage: "https://google.com",
  numberOfEpisodes: 34,
  name: 'name',
  numberOfSeasons: 2,
  originalLanguage: 'en',
  originalName: 'name',
  overview: 'overview',
  popularity: 12.323,
  posterPath: '',
  seasons: [
    SeasonModel(
      airDate: '',
      episodeCount: 7,
      id: 1,
      name: 'Winter',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 2,
    )
  ],
  status: 'status',
  tagline: 'tagline',
  type: 'Scripted',
  voteAverage: 3,
  voteCount: 3,
);

final testTVShowDetail = testTVShowDetailResponse.toEntity();

final testTVShowTable = TVShowTable.fromEntity(testTVShowDetail);

final testTVShowTableList = <TVShowTable>[testTVShowTable];

final testWatchlistTVShow = [testTVShowTable.toEntity()];

final testTVShowMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};