// import 'package:spotify/spotify.dart';

// class SpotifyAPI {

//   static Future<List<String>> searchSongs({required String query}) async {

    

//     // var credentials = SpotifyApiCredentials("00029c4f92334176aa56c6bd097bf0ef", "c3b73bd5867248cbad2fff0c8336ec4b");
//     // var spotify = SpotifyApi(credentials);


//     // try {
//     //   var search = await spotify.search
//     //   .get('metallica')
//     //   .first(2)
//     //   .catchError((err) => print((err as SpotifyException).message));
//     // if (search == null) {
//     //   return ;
//     // }

//     // search.forEach((pages) { 
//     //   pages.items!.forEach((item) {
//     //     if (item is TrackSimple) {
          
//           // final Map<String, int> someMap = {
//           //   "id": 1,
//           //   "name": 2,
//           //   "artists": item.artists
//           // };

//       //     return print("type: ${item.runtimeType}");
//       //     return print('Track:\n'
//       //         'id: ${item.id}\n'
//       //         'name: ${item.name}\n'
//       //         'href: ${item.href}\n'
//       //         'type: ${item.type}\n'
//       //         'uri: ${item.uri}\n'
//       //         'isPlayable: ${item.isPlayable}\n'
//       //         'artists: ${item.artists!.length}\n'
//       //         'availableMarkets: ${item.availableMarkets!.length}\n'
//       //         'discNumber: ${item.discNumber}\n'
//       //         'trackNumber: ${item.trackNumber}\n'
//       //         'explicit: ${item.explicit}\n'
//       //         '-------------------------------');
//       //   }
//       //  });
//     // });
//     // } catch (e) {
//     //   print(e);
//     // }

//     // search.forEach((pages) {
//     //   pages.items!.forEach((item) {
//     //     if (item is PlaylistSimple) {
//     //       return print('Playlist: \n'
//     //           'id: ${item.id}\n'
//     //           'name: ${item.name}:\n'
//     //           'collaborative: ${item.collaborative}\n'
//     //           'href: ${item.href}\n'
//     //           'trackslink: ${item.tracksLink!.href}\n'
//     //           'owner: ${item.owner}\n'
//     //           'public: ${item.owner}\n'
//     //           'snapshotId: ${item.snapshotId}\n'
//     //           'type: ${item.type}\n'
//     //           'uri: ${item.uri}\n'
//     //           'images: ${item.images!.length}\n'
//     //           '-------------------------------');
//     //     }
//     //     if (item is Artist) {
//     //       return print('Artist: \n'
//     //           'id: ${item.id}\n'
//     //           'name: ${item.name}\n'
//     //           'href: ${item.href}\n'
//     //           'type: ${item.type}\n'
//     //           'uri: ${item.uri}\n'
//     //           '-------------------------------');
//     //     }
//     //     if (item is TrackSimple) {
//     //       return print('Track:\n'
//     //           'id: ${item.id}\n'
//     //           'name: ${item.name}\n'
//     //           'href: ${item.href}\n'
//     //           'type: ${item.type}\n'
//     //           'uri: ${item.uri}\n'
//     //           'isPlayable: ${item.isPlayable}\n'
//     //           'artists: ${item.artists!.length}\n'
//     //           'availableMarkets: ${item.availableMarkets!.length}\n'
//     //           'discNumber: ${item.discNumber}\n'
//     //           'trackNumber: ${item.trackNumber}\n'
//     //           'explicit: ${item.explicit}\n'
//     //           '-------------------------------');
//     //     }
//     //     if (item is AlbumSimple) {
//     //       return print('Album:\n'
//     //           'id: ${item.id}\n'
//     //           'name: ${item.name}\n'
//     //           'href: ${item.href}\n'
//     //           'type: ${item.type}\n'
//     //           'uri: ${item.uri}\n'
//     //           'albumType: ${item.albumType}\n'
//     //           'artists: ${item.artists!.length}\n'
//     //           'availableMarkets: ${item.availableMarkets!.length}\n'
//     //           'images: ${item.images!.length}\n'
//     //           'releaseDate: ${item.releaseDate}\n'
//     //           'releaseDatePrecision: ${item.releaseDatePrecision}\n'
//     //           '-------------------------------');
//     //     }
//     //   });
//     // });
//   }

  
// }