import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/colors/colors.dart';
import 'package:music_player/model/dbfunctions.dart';
import 'package:music_player/model/favourites.dart';
import 'package:music_player/model/mostplayed.dart';
import 'package:music_player/model/playlistmodel.dart';
import 'package:music_player/model/recentlyplayed.dart';
import 'package:music_player/model/songmodel.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/screens/mainhome/functions/addToFavourites.dart';
import 'package:music_player/screens/mainhome/screens/now_playing_slider.dart';
import 'package:music_player/screens/splash.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AllSongsWidget extends StatefulWidget {
  const AllSongsWidget({super.key});

  @override
  State<AllSongsWidget> createState() => _AllSongsWidgetState();
}

final alldbsongs = SongBox.getInstance();
List<Songs> allDbsongs = alldbsongs.values.toList();
final OnAudioQuery _audioQuery = OnAudioQuery();
final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
final songbox = SongBox.getInstance();
final box4 = favocuritesbox.getInstance();
List<favourites> favdb = box4.values.toList();
//  final box = MostplayedBox.getInstance();
final List<MostPlayed> mostplayedsong = mostbox.values.toList();

class _AllSongsWidgetState extends State<AllSongsWidget> {
  bool istaped = true;
  // bool isalready = true;

  List<Audio> convertAudios = [];

  @override
  void initState() {
    // TODO: implement initState
    List<Songs> dbsongs = songbox.values.toList();
    for (var item in dbsongs) {
      convertAudios.add(Audio.file(item.songurl!,
          metas: Metas(
              title: item.songname,
              artist: item.artist,
              id: item.id.toString())));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    @override
    void dispose() {
      audioPlayer.dispose();
      print('dispose');
      super.dispose();
    }

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5, bottom: 5),
              child: Text('All Songs',
                  style: GoogleFonts.kanit(fontSize: 20, color: colorwhite)),
            ),
          ],
        ),
        ///////////////////
        ValueListenableBuilder<Box<Songs>>(
          valueListenable: songbox.listenable(),
          builder: ((context, Box<Songs> allsongbox, child) {
            List<Songs> allDbsongs = allsongbox.values.toList();
            // List<MostPlayed> allmostplayedsongs = mostplayedsongs.values.toList();

            if (allDbsongs == null) {
              print('no songs');
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: allDbsongs.length,
              itemBuilder: ((context, songindex) {
                RecentlyPlayed rsongs;
                Songs songs = allDbsongs[songindex];
                MostPlayed mostsong = mostplayedsong[songindex];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 5),
                  child: ListTile(
                    onTap: () {
                      audioPlayer.open(
                        // Audio.file(allDbsongs[songindex].songurl!),
                        Playlist(audios: convertAudios, startIndex: songindex),
                        headPhoneStrategy:
                            HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                        showNotification: true,
                      );
                      setState(() {});
                      rsongs = RecentlyPlayed(
                          id: songs.id,
                          artist: songs.artist,
                          duration: songs.duration,
                          songname: songs.songname,
                          songurl: songs.songurl);
                      NowPlayingSlider.enteredvalue.value = songindex;
                      updateRecentlyPlayed(rsongs);
                      updatePlayedSongsCount(mostsong, songindex);
                      print(songindex);
                      print(allDbsongs[songindex].songname!);
                    },
                    leading: QueryArtworkWidget(
                      artworkHeight: vheight * 0.06,
                      artworkWidth: vheight * 0.06,
                      keepOldArtwork: true,
                      artworkBorder: BorderRadius.circular(10),
                      id: allDbsongs[songindex].id!,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/music.jpeg',
                          height: vheight * 0.06,
                          width: vheight * 0.06,
                        ),
                      ),
                    ),
                    title: Text(
                      allDbsongs[songindex].songname!,
                      style: GoogleFonts.kanit(color: colorwhite),
                    ),
                    subtitle: Text(allDbsongs[songindex].artist ?? "No Artist",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.kanit(
                            color: colorwhite.withOpacity(0.7), fontSize: 12)),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (checkFavoriteStatus(
                                  songindex, BuildContext)) {
                                addToFavourites(songindex);
                                final snackbar = SnackBar(
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Added to Favourites',
                                      style: GoogleFonts.kanit(
                                          color: colordark, fontSize: 15),
                                    ),
                                  ),
                                  backgroundColor: colorextralight,
                                  dismissDirection: DismissDirection.down,
                                  elevation: 10,
                                  padding: EdgeInsets.only(top: 10, bottom: 15),
                                );
                                // addToFavorites1(songindex, favourites, context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                              } else if (!checkFavoriteStatus(
                                  songindex, BuildContext)) {
                                removefavourite(songindex);
                              }
                              setState(
                                () {
                                  istaped = !istaped;
                                },
                              );
                              print(allDbsongs[songindex].songname!);
                            },
                            icon: Icon(Icons.favorite,
                                color: (checkFavoriteStatus(
                                        songindex, BuildContext))
                                    ? Color.fromARGB(255, 85, 85, 85)
                                    : Color.fromARGB(255, 255, 255, 255))),
                        IconButton(
                          onPressed: () {
                            showOptions(context, songindex);
                          },
                          icon: const Icon(Icons.more_vert),
                          color: colorwhite,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        )
      ],
    );
  }
}

showPlaylistOptions(BuildContext context, int songindex) {
  Songs playsong;
  // final List<PlaylistModel> playlistsong1 = [];
  final box = PlaylistSongsbox.getInstance();
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: colorextralight,
          alignment: Alignment.bottomCenter,
          content: Container(
            height: 200,
            width: vwidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<Box<PlaylistSongs>>(
                      valueListenable: box.listenable(),
                      builder:
                          (context, Box<PlaylistSongs> playlistsongs, child) {
                        List<PlaylistSongs> playlistsong =
                            playlistsongs.values.toList();
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: playlistsong.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              onTap: () {
                                PlaylistSongs? playsongs =
                                    playlistsongs.getAt(index);
                                List<Songs> playsongdb =
                                    playsongs!.playlistssongs!;
                                List<Songs> songdb = songbox.values.toList();
                                bool isAlreadyAdded = playsongdb.any(
                                    (element) =>
                                        element.id == songdb[songindex].id);
                                if (!isAlreadyAdded) {
                                  playsongdb.add(
                                    Songs(
                                      songname: songdb[songindex].songname,
                                      artist: songdb[songindex].artist,
                                      duration: songdb[songindex].duration,
                                      songurl: songdb[songindex].songurl,
                                      id: songdb[songindex].id,
                                    ),
                                  );
                                }
                                playlistsongs.putAt(
                                    index,
                                    PlaylistSongs(
                                        playlistname:
                                            playlistsong[index].playlistname,
                                        playlistssongs: playsongdb));
                                print(
                                    'song added to${playlistsong[index].playlistname}');
                                // allDbsongs.add(playsong);
                                // addToPlaylist(playsong, index);
                                // Hive.box(playlistsongs.put(playlistsongs, playsong));
                                Navigator.pop(context);
                              },
                              title: Text(
                                playlistsong[index].playlistname!,
                                style: GoogleFonts.kanit(color: colorblack),
                              ),
                            );
                          }),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

showOptions(BuildContext context, int index) {
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: colorextralight,
          alignment: Alignment.bottomCenter,
          content: Container(
            height: 150,
            width: vwidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        if (checkFavoriteStatus(index, BuildContext)) {
                          addToFavourites(index);
                        } else if (!checkFavoriteStatus(index, BuildContext)) {
                          removefavourite(index);
                        }
                        setState(() {});
                        // setState(() {
                        //   isalready = !isalready;
                        // });
                        // isalready = true;
                        // if (checkFavoriteStatus(index, BuildContext) == true) {
                        //   isalready == false;
                        //   // addToFavourites(index, isalready);
                        // }
                        // Navigator.pop(context);
                        // // if (checkFavoriteStatus(index, context) == false) {
                        // //   removefavourite(index);
                        // // }
                        Navigator.pop(context);
                      },
                      icon: (checkFavoriteStatus(index, context))
                          ? const Icon(
                              Icons.favorite_border_outlined,
                              color: colorblack,
                            )
                          : Icon(
                              Icons.favorite,
                              color: colorblack,
                            ),
                      label: (checkFavoriteStatus(index, context))
                          ? Text(
                              'Add to Favourites',
                              style: GoogleFonts.kanit(
                                  color: colorblack, fontSize: 17),
                            )
                          : Text(
                              'Remove from Favourites',
                              style: GoogleFonts.kanit(
                                  color: colorblack, fontSize: 17),
                            )),
                  TextButton.icon(
                      onPressed: () {
                        showPlaylistOptions(context, index);
                      },
                      icon: const Icon(
                        Icons.playlist_add,
                        color: colorblack,
                      ),
                      label: Text(
                        'Add to Playlist',
                        style:
                            GoogleFonts.kanit(color: colorblack, fontSize: 17),
                      )),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.repeat,
                      color: colorblack,
                    ),
                    label: Text(
                      'Repeat',
                      style: GoogleFonts.kanit(color: colorblack, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
