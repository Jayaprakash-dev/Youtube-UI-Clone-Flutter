import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yt_ui_clone/app/home_screen/bloc/home_bloc.dart';
import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';

import '../../global/widgets/app_bar.dart';
import '../widgets/yt_videos_list_view.dart';

class HomePage extends StatefulWidget {
  final Future<DataState<List<VideoEntity>>> videosList;
  final bool isRebuildReq;

  const HomePage({
    super.key, 
    required this.videosList, 
    this.isRebuildReq = true,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<DataState<List<VideoEntity>>> _videosList;

  @override
  void initState() {
    super.initState();
    _videosList = widget.videosList;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CustomAppBar(),
        SliverToBoxAdapter(
          child: SizedBox(height: 10.h),
        ),
        FutureBuilder(
          future: _videosList,
          builder:(context, snapshot) {
            if (snapshot.hasData && snapshot.data is DataSuccess) {
              return YtVideosListViewWrapper(videosList: snapshot.data!.data!);
            } else if (snapshot.hasData && snapshot.data is DataException) {
              BlocProvider.of<HomeBloc>(context).add(HomeErrorEvent(error: snapshot.data!.error!));
              return const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Colors.red)));
            } else {
              return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
            }
          }
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRebuildReq) {
      _videosList = widget.videosList;
    }
  }
}