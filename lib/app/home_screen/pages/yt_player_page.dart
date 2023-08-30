// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:yt_ui_clone/app/global/widgets/bottom_nav_bar.dart';
import 'package:yt_ui_clone/app/home_screen/widgets/yt_player_maximized.dart';
import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';

import '../widgets/yt_player_minimized.dart';


class YoutubePlayerPage extends StatefulWidget {

  final VideoEntity activeVideo;
  final double maxWidth;
  final double maxHeight;
  final Future<DataState<List<VideoEntity>>> suggestionVideosList;

  const YoutubePlayerPage({
    super.key,
    required this.activeVideo,
    required this.maxWidth,
    required this.maxHeight,
    required this.suggestionVideosList,
  });

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> with TickerProviderStateMixin {

  late YoutubePlayerController _ytPlayerController;

  late AnimationController _dragHAnimationController;
  late Animation<double> _dragHAnimationtween;

  late ValueNotifier<double> _heightNotifier;
  late ValueNotifier<double> _widthNotifier;

  late double _dragHeight;
  late double _slidingWidth;

  late double _startHeight;
  static const double _minHeight = 66;

  static const double _minWidth = 121;

  late double _aspectRatio;

  static const _miniplayerViewTransitionPoint = 130;

  final Widget bottomNavBarWidget = const BottomNavBar(index: 0);

  bool _playingVideo = true;

  late String _prevActiveVideoId;

  // there is no way to set player's 'hideControls' prop to false,
  // so there will be two check statements to control the creation of a new player instance
  late bool _isMaxPlayerControllerInit, _isMinPlayerControllerInit;

  @override
  void initState() {
    super.initState();

    _isMaxPlayerControllerInit = true;
    _isMinPlayerControllerInit = false;
    _prevActiveVideoId = widget.activeVideo.videoId!;

    _ytPlayerController = YoutubePlayerController(
      initialVideoId: widget.activeVideo.videoId!,
      flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
      ),
    );

    _heightNotifier = ValueNotifier(widget.maxHeight);
    _dragHeight = _heightNotifier.value;

    _widthNotifier = ValueNotifier(widget.maxWidth);
    _slidingWidth = _widthNotifier.value;

    _dragHAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(_dargAnimationListener);
    
    // In this case, the aspect ratio is maintained by calculating the height to width
    // it better suits for the animation
    _aspectRatio = widget.maxHeight / widget.maxWidth;
  }

  @override
  void dispose() {
    _ytPlayerController.dispose();
    _dragHAnimationController.dispose();
    _heightNotifier.dispose();
    _widthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return _playingVideo
     ? AnimatedBuilder(
      animation: _dragHAnimationController,
      builder: (context, _) => SafeArea(
        bottom: false,
        child: GestureDetector(
          onPanStart: _dragStartEventhandler,
          onPanUpdate: _dragUpdateEventHandler,
          onPanEnd: _dragEndEventHandler,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder(
              valueListenable: _heightNotifier,
              builder: (context, value, _) => LayoutBuilder(
                builder: (context, constraints) {
              
                  // yt player maximized view
                  if (value > _miniplayerViewTransitionPoint) {

                    if (!_isMaxPlayerControllerInit || (widget.activeVideo.videoId != _prevActiveVideoId)) {
                      _isMaxPlayerControllerInit = true;
                      _isMinPlayerControllerInit = false;
                      _prevActiveVideoId = widget.activeVideo.videoId!;

                      _ytPlayerController = YoutubePlayerController(
                        initialVideoId: widget.activeVideo.videoId!,
                        flags: const YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                        ),
                      );
                    }

                    return Container(
                      color: const Color.fromRGBO(27, 28, 30, 1),
                      width: double.infinity,
                      height: _heightNotifier.value,
                      child: YoutubePlayerMaximizedView(
                        activeVideo: widget.activeVideo,
                        ytPlayerController: _ytPlayerController,
                        suggestionVideosList: widget.suggestionVideosList,
                        dragStartCallback: _dragStartEventhandler,
                        dragUpdateCallback: _dragUpdateEventHandler,
                        dragEndCallback: _dragEndEventHandler,
                      ),
                    );
                  }
                      
                  // yt player minimized view
                  else {

                    if (!_isMinPlayerControllerInit || (widget.activeVideo.videoId != _prevActiveVideoId)) {
                      _isMaxPlayerControllerInit = false;
                      _isMinPlayerControllerInit = true;
                      _prevActiveVideoId = widget.activeVideo.videoId!;

                      _ytPlayerController = YoutubePlayerController(
                        initialVideoId: widget.activeVideo.videoId!,
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                          hideControls: true,
                        ),
                      );
                    }

                    return ValueListenableBuilder(
                      valueListenable: _widthNotifier,
                      child: bottomNavBarWidget,
                      builder: (context, value, child) => Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 13, right: 13, bottom: 84),
                            width: double.infinity,
                            height: _heightNotifier.value,
                            child: YoutubePlayerMinimizedView(
                              activeVideo: widget.activeVideo,
                              controller: _ytPlayerController,
                              playerWidth: _widthNotifier.value,
                              closeVideo: _closeActiveVideo,
                            ),
                          ),
                          child!,
                        ],
                      ),
                    );
                  }
                }
              ),
            ),
          ),
        ),
      ),
    )
    : const Stack(children: [ BottomNavBar(index: 0) ],);
  }

  void _dragStartEventhandler(DragStartDetails details) {
    _startHeight = _dragHeight;
  }

  void _dragUpdateEventHandler(DragUpdateDetails details) {
    _dragHeight = widget.maxHeight - details.localPosition.dy;
    _slidingWidth = _dragHeight * _aspectRatio;

    if (_dragHeight >= _minHeight && _dragHeight <= widget.maxHeight) _heightNotifier.value = _dragHeight;
    
    if (_dragHeight <= _miniplayerViewTransitionPoint && _slidingWidth >= _minWidth && _slidingWidth <= widget.maxWidth) {
      _widthNotifier.value = _slidingWidth;
    }
  }

  void _dragEndEventHandler(DragEndDetails details) {
    if (_dragHeight >= widget.maxHeight || _dragHeight < _minHeight) return;

    if (_startHeight < _dragHeight) {
      _snapToTopPosition(_dragHeight, widget.maxHeight);
    } else {
      _snapToBottomPosition(_dragHeight, _minHeight);
    }
    _startHeight = _dragHeight;
  }

  void _animateDragging(double start, double end) {
    _dragHAnimationtween = Tween<double>(
      begin: start, // max-height
      end: end, // min-height
    ).animate(_dragHAnimationController);

    _dragHAnimationController.reset();
    _dragHAnimationController.forward();
  }

  void _snapToTopPosition(double start, double end) {
    if (start <= (widget.maxHeight / 2.5)) {
      _snapToBottomPosition(start, _minHeight);
    } else {
      _animateDragging(start, end);
    }
  }
  
  void _snapToBottomPosition(double start, double end) { 
    _animateDragging(start, end);
  }

  void _dargAnimationListener() {
    _dragHeight = _dragHAnimationtween.value;
    _slidingWidth = _dragHeight * _aspectRatio;

    if (_dragHeight <= _miniplayerViewTransitionPoint && _slidingWidth >= _minWidth && _slidingWidth <= widget.maxWidth) {
      _widthNotifier.value = _slidingWidth;
    }

    if (_dragHeight >= _minHeight && _dragHeight <= widget.maxHeight) _heightNotifier.value = _dragHeight;
  }

  @override
  void didUpdateWidget(covariant YoutubePlayerPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    //if (oldWidget.activeVideo.videoId != widget.activeVideo.videoId) {

    //  print('Player transitioning to new video ${widget.activeVideo.videoId!}');

    //  _ytPlayerController.dispose();

    //  _ytPlayerController = YoutubePlayerController(
    //    initialVideoId: widget.activeVideo.videoId!,
    //    flags: const YoutubePlayerFlags(
    //      autoPlay: true,
    //      mute: false,
    //    ),
    //  );

    //  _loadVideo();
    //} else 
    if (!_playingVideo) {
      _loadVideo();
    }
  }

  void _closeActiveVideo() {
    setState(() {
      _playingVideo = false;
    });
  }

  void _loadVideo() {
    setState(() {
      _playingVideo = true;
    });
  }
}