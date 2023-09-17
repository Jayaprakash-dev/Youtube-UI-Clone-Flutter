import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';

import '../../global/widgets/app_bar.dart';
import '../widgets/yt_videos_list_view.dart';

class HomePage extends StatefulWidget {
  final List<VideoEntity> videosList;

  const HomePage({
    super.key, 
    required this.videosList, 
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CustomAppBar(),
        SliverToBoxAdapter(
          child: SizedBox(height: 10.h),
        ),
        YtVideosListViewWrapper(videosList: widget.videosList),
      ],
    );
  }
}