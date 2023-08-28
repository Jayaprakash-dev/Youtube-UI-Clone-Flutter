import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yt_ui_clone/app/home_screen/bloc/home_bloc.dart';
import 'package:yt_ui_clone/app/global/widgets/app_bar.dart';
import 'package:yt_ui_clone/app/home_screen/pages/home_page.dart';
import 'package:yt_ui_clone/app/home_screen/pages/yt_player_page.dart';

import '../global/widgets/bottom_nav_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 28, 30, 1),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const CustomScrollView(
              slivers: [
                CustomAppBar(),
                SliverFillRemaining(
                  child: Stack(
                    children: [
                      Center( child: CircularProgressIndicator() ),
                      BottomNavBar(index: 0)
                    ],
                  ),
                  ),
              ],
            );
          case HomeSuccessState:
            return RefreshIndicator(
              onRefresh: () async => BlocProvider.of<HomeBloc>(context).add(AppStarted()),
              edgeOffset: 60.h,
              backgroundColor: Colors.black,
              child: Stack(
                children: [
                  HomePage(videosList: state.videos!),
                  const BottomNavBar(index: 0),
                ],
              )
            );
          case HomeVideoPlayer:
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async => BlocProvider.of<HomeBloc>(context).add(AppStarted()),
                  edgeOffset: 60.h,
                  backgroundColor: Colors.black,
                  child: HomePage(videosList: state.videos!)
                ),
                YoutubePlayerPage(
                  activeVideo: (state as HomeVideoPlayer).activeVideo,
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                  suggestionVideosList: state.suggestionVideosList,
                ),
              ],
            );
          default:
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
        }
      },
    );
  }
}