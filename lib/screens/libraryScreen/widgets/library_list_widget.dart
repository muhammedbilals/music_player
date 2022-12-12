import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/colors/colors.dart';
import 'package:music_player/screens/mainhome/widgets/all_songs_widget.dart';

class LibraryList extends StatelessWidget {
  LibraryList({super.key});
  List<String> songimage = [
    'assets/images/hanzimmer.jpg',
    'assets/images/hanszimmer.jpg',
    'assets/images/tame-impala-eventually-1400px_800.jpg',
  ];
  List<String> author = [
    'Playlist',
    'Playlist',
    'Playlist',
  ];
  List<String> songs = [
    'Fav Songs',
    'Hans Zimmer Fav',
    'Imapala Fav',
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: ((context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 0),
            child: ListTile(
              leading: ClipRRect(
                  child: Image.asset(
                songimage[index],
              )),
              title: Text(
                songs[index],
                style: GoogleFonts.kanit(color: colorwhite, fontSize: 25),
              ),
              subtitle: Text(author[index],
                  style: GoogleFonts.kanit(
                      color: colorwhite.withOpacity(0.7), fontSize: 15)),
            ),
          )),
    );
  }
}