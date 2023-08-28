import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yt_ui_clone/app/home_screen/bloc/home_bloc.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';

class YtVideoListTile extends StatelessWidget {
  final VideoEntity video;

  const YtVideoListTile({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Column(
        children: [
          Stack(
            children: [
              // youtube video tile
              GestureDetector(
                onTap: () => BlocProvider.of<HomeBloc>(context).add(
                  NavigateToYtPlayer(activeVideo: video, videoCategorgId: video.categoryId!)
                ),
                child: FutureBuilder(
                  future: video.thumbnails.last.getImageBytes(),
                  builder: (context, snapshot) {

                    if (snapshot.hasData) {
                      return Container(
                        width: double.infinity,
                        height: 230.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: MemoryImage(snapshot.data!)
                          ),
                          borderRadius: BorderRadius.circular(8.r)
                        ),
                      );
                    }

                    else {
                      return Container(
                        width: double.infinity,
                        height: 230.h,
                        color: Colors.black,
                      );
                    }

                  }
                ),
              ),
              // youtube video time duration widget
              Positioned(
                right: 10.w,
                bottom: 8.h,
                child: Container(
                  padding: EdgeInsets.only(top: 3.h, left: 7.w, right: 7.w, bottom: 3.h),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(220, 24, 24, 24),
                    borderRadius: BorderRadius.circular(5.r)
                  ),
                  child:   Text(
                    video.contentDetails.target?.videoDuration ?? "00:00",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.sp, letterSpacing: 0.5)
                  ),
                ),
              )
            ]
          ),
          Container(
            color: const Color.fromRGBO(27, 28, 30, 1),
            padding: EdgeInsets.only(top: 22.h, bottom: 22.h),
            //height: 80,
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // channel thumbnail future builder
                FutureBuilder(
                  future: video.channel.target!.thumbnails.last.getImageBytes(),
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
                SizedBox(width: 10.w,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: cWidth,
                      child: Text(
                        video.title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'YtSans',
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(220, 255, 255, 255),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 7.h,),
                    Row(
                      children: [
                        Text(
                          video.channelTitle!.length > 17 
                            ? 
                            video.channelTitle!.substring(0, 16)
                            :
                            video.channelTitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            //fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 4.w,),
                        Center(
                          child: Text('.', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w900),),
                        ),
                        SizedBox(width: 4.w,),
                        Text(
                          video.statistics.target?.parseViewCount ?? '0K',
                          style: TextStyle(
                            //fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 4.w,),
                        Center(
                          child: Text('.', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w900)),
                        ),
                        SizedBox(width: 4.w,),
                        Text(
                          video.parsePublishedDate(),
                          style: TextStyle(
                            //fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                //SizedBox(width: 5.w,),
                const Icon(Icons.more_vert, color: Color.fromARGB(170, 255, 255, 255))
              ],
            ),
          )
        ],
      ),
    );
  }
}