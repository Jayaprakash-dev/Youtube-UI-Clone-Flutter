import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWrapper extends StatelessWidget {

  final YoutubePlayerController controller;

  const YoutubePlayerWrapper({
    super.key,
    required this.controller,
  });
  
  @override
  Widget build(BuildContext context) {

    return YoutubePlayer(
      key: Key(controller.initialVideoId),
      controller: controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.red,
      progressColors: const ProgressBarColors(
        playedColor: Colors.red,
        handleColor: Colors.redAccent,
      ),
      // ignore: avoid_print
      onReady: () {
        print('player ready');
      },
    );
  }
}