import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/colors/colors.dart';
import 'package:music_player/screens/mainhome/widgets/now_playing_playbutton_row.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  double _value = 6;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colordark,
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                      decoration: BoxDecoration(
                          color: colorextralight,
                          borderRadius: BorderRadius.circular(30)),
                      width: 40,
                      height: 40,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.expand_more,
                          color: colorblack,
                          size: 25,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70.0),
                  child: Text(
                    'Now Playing',
                    style: GoogleFonts.kanit(fontSize: 40, color: colorwhite),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/interstellar.jpg')),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'New Person, Same Old Mistakes',
                        style:
                            GoogleFonts.kanit(fontSize: 25, color: colorwhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Tame Impala',
                        style: GoogleFonts.kanit(
                            fontSize: 15, color: colorwhite.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border_outlined,
                      color: colorwhite,
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Slider(
              value: _value,
              min: 0,
              max: 100,
              // divisions: (3600 / 30 - 1).toInt(),
              // value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                  print(_value);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _value.toString(),
                    style: GoogleFonts.kanit(
                        fontSize: 15, color: colorwhite.withOpacity(0.7)),
                  ),
                  Text(
                    (_value.toString()),
                    style: GoogleFonts.kanit(
                        fontSize: 15, color: colorwhite.withOpacity(0.7)),
                  )
                ],
              ),
            ),
            NowPlayingPlayButtonRow()
          ],
        ),
      ),
    );
  }
}
// extension on Duration {
//   String toHHmmss() {
//     var microseconds = inMicroseconds;

//     var hours = microseconds ~/ Duration.microsecondsPerHour;
//     microseconds = microseconds.remainder(Duration.microsecondsPerHour);

//     if (microseconds < 0) microseconds = -microseconds;

//     var minutes = microseconds ~/ Duration.microsecondsPerMinute;
//     microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

//     var minutesPadding = minutes < 10 ? "0" : "";

//     var seconds = microseconds ~/ Duration.microsecondsPerSecond;
//     microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

//     var secondsPadding = seconds < 10 ? "0" : "";

//     return "$hours:"
//         "$minutesPadding$minutes:"
//         "$secondsPadding$seconds";
//   }
// }