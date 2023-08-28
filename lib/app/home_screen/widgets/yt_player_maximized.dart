// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:yt_ui_clone/app/home_screen/bloc/home_bloc.dart';
import 'package:yt_ui_clone/app/home_screen/widgets/yt_player_wrapper.dart';
import 'package:yt_ui_clone/app/home_screen/widgets/yt_videos_list_view.dart';
import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';


class YoutubePlayerMaximizedView extends StatefulWidget {

  final VideoEntity activeVideo;
  final YoutubePlayerController ytPlayerController;
  final Future<DataState<List<VideoEntity>>> suggestionVideosList;

  // callbacks
  final void Function(DragStartDetails details) dragStartCallback;
  final void Function(DragUpdateDetails details) dragUpdateCallback;
  final void Function(DragEndDetails details) dragEndCallback;

  const YoutubePlayerMaximizedView({
    super.key,
    required this.activeVideo,
    required this.ytPlayerController,
    required this.suggestionVideosList,
    required this.dragStartCallback,
    required this.dragUpdateCallback,
    required this.dragEndCallback,
  });

  @override
  State<YoutubePlayerMaximizedView> createState() => _YoutubePlayerMaximizedViewState();
}

class _YoutubePlayerMaximizedViewState extends State<YoutubePlayerMaximizedView> {

  bool _expandedView = false;

  Widget _styleDescVideoInfo(String val, String text) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Stack(
            children: [
              YoutubePlayerWrapper(
                controller: widget.ytPlayerController,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: widget.dragStartCallback,
                onPanUpdate: widget.dragUpdateCallback,
                onPanEnd: widget.dragEndCallback,
              ),
            ],
          ),
        ),
        _expandedView
        ? Flexible( // yt video description view
          flex: 5,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[100]!, width: 0.5))
                    ),
                    child: Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'YtSans',
                            letterSpacing: .4
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedView = !_expandedView;
                            });
                          },
                          child: const Icon(Icons.close, color: Colors.white, size: 30)
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 14, right: 14, bottom: 20),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.activeVideo.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'YTSans',
                              fontSize: 20,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 17, bottom: 10),
                          padding: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[100]!, width: 0.5))
                          ),
                          child: Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            direction: Axis.horizontal,
                            children: [
                              _styleDescVideoInfo(
                                widget.activeVideo.parseCount(
                                  widget.activeVideo.statistics.target!.likeCount!
                                ), 
                                'Likes'
                              ),
                              _styleDescVideoInfo(
                                widget.activeVideo.parseCount(
                                  widget.activeVideo.statistics.target!.viewCount!
                                ), 
                                'Views'
                              ),
                              _styleDescVideoInfo(
                                '${widget.activeVideo.publishedAt!.day.toString()} '
                                '${DateFormat("MMMM").format(widget.activeVideo.publishedAt!).substring(0,3)} ',
                                widget.activeVideo.publishedAt!.year.toString()
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        RichText(text: buildDescription(widget.activeVideo.desc!)),
                        //Text(widget.activeVideo.desc!, style: const TextStyle(color: Colors.white),),
                        const SizedBox(height: 15),
                        Text(
                          _styleVideoTags(widget.activeVideo.tags),
                          style: const TextStyle(
                            color: Colors.blue,
                            wordSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        : Flexible(
          flex: 5,
          fit: FlexFit.loose,
          // video info wrapper
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            width: double.infinity,
            height: double.infinity,
            child: CustomScrollView(
              slivers:[ SliverToBoxAdapter(
                child: Column(
                  children: [
                    // video title & desc wrapper
                    ExpansionTile(
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      title: Text(
                        widget.activeVideo.title!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'YTSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      subtitle: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            // video views wrapper
                            Text(
                              '${widget.activeVideo.statistics.target!.parseViewCount} views',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                            // video publised date wrapper
                            const SizedBox(width: 8,),
                            Text(
                              widget.activeVideo.parsePublishedDate(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                            // video tags wrapper
                            const SizedBox(width: 8,),
                            SizedBox(
                              width: 140.w,
                              child: Text(
                                _styleVideoTags(widget.activeVideo.tags),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onExpansionChanged: (_) => setState(() {
                        _expandedView = !_expandedView;
                      }),
                    ),
                    const SizedBox(height: 6.0,),
                    // channel info wrapper
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        children: [
                          // channel thumbnail future builder
                          FutureBuilder(
                            future: widget.activeVideo.channel.target!.thumbnails.last.getImageBytes(),
                            builder: (context, snapshot) {
                              
                              if (!snapshot.hasData) {
                                return CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 26.r,
                                );
                              }
                
                              else {
                                return CircleAvatar(
                                  backgroundImage: MemoryImage(snapshot.data!),
                                  radius: 26.r,
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 14,),
                          Row(
                            children: [
                              Text(
                                widget.activeVideo.channelTitle!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                widget.activeVideo.channel.target!.statistics.target!.parseCount(
                                  widget.activeVideo.channel.target!.statistics.target!.subscriberCount
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Subscribe',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // video action buttons wrapper
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // like and dislike button wrapper
                          Container(
                            padding: const EdgeInsets.only(left: 0, right: 1),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.thumb_up_outlined)
                                ),
                                Text(widget.activeVideo.parseCount(widget.activeVideo.statistics.target!.likeCount!)),
                                const VerticalDivider(
                                  color: Colors.black,
                                  thickness: 1,
                                  indent: 12,
                                  endIndent: 12,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.thumb_down_outlined)
                                ),
                              ],
                            ),
                          ),
                          // share button wrapper
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.only(left: 0, right: 10),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(39, 39, 39, 1),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share_rounded, color: Colors.white,)
                                ),
                                const Text('Share', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          // save btn wrapper
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.only(left: 0, right: 10),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(39, 39, 39, 1),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add_circle_outline_outlined, color: Colors.white,)
                                ),
                                const Text('Save', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          // download button wrapper
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.only(left: 0, right: 10),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(39, 39, 39, 1),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.arrow_circle_down_rounded, color: Colors.white,)
                                ),
                                const Text('Download', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          // YT shorts button wrapper
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.only(left: 6, right: 10),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(39, 39, 39, 1),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.videocam_outlined, color: Colors.white,)
                                ),
                                const Text('Shorts', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          // report button wrapper
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.only(left: 6, right: 10),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(39, 39, 39, 1),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.report_outlined, color: Colors.white,)
                                ),
                                const Text('Report', style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // youtube comments wrapper
                    Container(
                      margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                      width: double.infinity,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(39, 39, 39, 1),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      child: ExpansionTile(
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        title: Text(
                          'Comments ${widget.activeVideo.parseCount(widget.activeVideo.statistics.target!.commentCount!)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[100],
                      height: 25,
                      thickness: 0.17,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 18, bottom: 15),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Up next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    // suggestion videos wrapper widget
                    //ListView.builder(
                    //  shrinkWrap: true,
                    //  physics: const NeverScrollableScrollPhysics(),
                    //  itemCount: widget.suggestionVideosList.length,
                    //  itemBuilder: (context, index) => YtVideoListTile(video: widget.suggestionVideosList[index]),
                    //),
                  ],
                ),
              ),
              FutureBuilder(
                key: ObjectKey(widget.suggestionVideosList.hashCode),
                future: widget.suggestionVideosList,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data is DataSuccess) {
                    return YtVideosListViewWrapper(videosList: snapshot.data!.data!);
                  } else if (snapshot.hasData && snapshot.data is DataException) {
                    BlocProvider.of<HomeBloc>(context).add(HomeErrorEvent(error: snapshot.data!.error!));
                    return const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Colors.red)));
                  } else {
                    return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                  }
                },
              )
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  String _styleVideoTags(List<String>? tags) {
    if (tags == null) return '';

    String videoTags = '';

    for (String tag in tags) {
      videoTags += '#$tag ';
    }

    return videoTags;
  }

  TextSpan buildDescription(String text) {
    final RegExp regExpLinkPattern = RegExp(r'(https?)([^\s]+)');
    final List<TextSpan> textSpans = [];

    final Iterable<RegExpMatch> matches = regExpLinkPattern.allMatches(text);
    
    int index = 0;

    for (final RegExpMatch match in matches) {
      final String beforeMatchText = text.substring(index, match.start);
      if (beforeMatchText.isNotEmpty) {
        textSpans.add(
          TextSpan(
            text: beforeMatchText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              letterSpacing: 0.2
            ),
          )
        );
      }

      final String? matchText = match.group(1);
      if (matchText != null) {
        textSpans.add(
          TextSpan(
            text: matchText + (match.group(2) ?? ''),
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 15,
              letterSpacing: 0.2
            ),
          )
        );
      }

      index = match.end;
    }

    return TextSpan(children: textSpans);
  }

  @override
  void didUpdateWidget(covariant YoutubePlayerMaximizedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeVideo.videoId != widget.activeVideo.videoId) {
      print('Rebuilding suggestion videos List');
    }
  }
}