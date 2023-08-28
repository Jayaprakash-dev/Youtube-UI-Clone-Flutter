import 'package:flutter/material.dart';
import 'package:yt_ui_clone/app/home_screen/widgets/yt_video_list_tile.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';

class YtVideosListViewWrapper extends StatefulWidget {

  final List<VideoEntity> videosList;
  
  const YtVideosListViewWrapper({super.key, required this.videosList});

  @override
  State<YtVideosListViewWrapper> createState() => _YtVideosListViewWrapperState();
}

class _YtVideosListViewWrapperState extends State<YtVideosListViewWrapper> {

  @override
  Widget build(BuildContext context) {

    return SliverList.builder(
      itemCount: widget.videosList.length,
      itemBuilder: (context, index) {
        final VideoEntity video = widget.videosList.elementAt(index);
        return YtVideoListTile(video: video);
      },
    );
  }
}