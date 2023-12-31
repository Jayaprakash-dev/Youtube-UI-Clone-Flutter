import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:yt_ui_clone/app/home_screen/widgets/yt_player_wrapper.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';

// ignore: must_be_immutable
class YoutubePlayerMinimizedView extends StatefulWidget {
  
  final VideoEntity activeVideo;
  final YoutubePlayerController controller;

  double playerWidth;

  // callbacks
  final void Function() closeVideo;

  YoutubePlayerMinimizedView({
    super.key,
    required this.activeVideo,
    required this.controller,
    required this.playerWidth,
    required this.closeVideo,
  });

  @override
  State<YoutubePlayerMinimizedView> createState() => _YoutubePlayerMinimizedViewState();
}

class _YoutubePlayerMinimizedViewState extends State<YoutubePlayerMinimizedView> {

  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.controller.value.isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(13), bottomLeft: Radius.circular(13)),
              child: YoutubePlayerWrapper(
                controller: widget.controller,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              padding: const  EdgeInsets.only(top: 12, left: 10, bottom: 4, right: 5),
              width: MediaQuery.of(context).size.width - 50,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(27, 28, 30, 1),
                borderRadius: BorderRadius.only(topRight: Radius.circular(13), bottomRight: Radius.circular(13)),
              ),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 200,
                          child: Text(
                            widget.activeVideo.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'YtSans',
                              fontSize: 16
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.activeVideo.channelTitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.5
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // manages play/pause in minimized view
                  GestureDetector(
                    onTap: playPauseClickHandler,
                    child: Icon( _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 30)
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.closeVideo,
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 30)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void playPauseClickHandler() {
    if (_isPlaying) {
      widget.controller.pause();
      setState(() { _isPlaying = false; });
    } else {
      widget.controller.play();
      setState(() { _isPlaying = true; });
    }
  }
}