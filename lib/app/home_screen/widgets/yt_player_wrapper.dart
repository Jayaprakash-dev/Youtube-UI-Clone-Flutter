import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWrapper extends StatefulWidget {

  final double playerWidth;
  final YoutubePlayerController controller;

  const YoutubePlayerWrapper({
    super.key,
    required this.playerWidth,
    required this.controller,
  });

  @override
  State<YoutubePlayerWrapper> createState() => _YoutubePlayerWrapperState();
}

class _YoutubePlayerWrapperState extends State<YoutubePlayerWrapper> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.playerWidth,
      height: double.infinity,
      child: YoutubePlayer(
        key: ObjectKey(widget.controller.hashCode),
        controller: widget.controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        // ignore: avoid_print
        onReady: () => print('player ready'),
      ),
    );
  }
}