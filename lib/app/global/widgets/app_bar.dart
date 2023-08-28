import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      //toolbarHeight: 70.h,
      pinned: false,
      backgroundColor: const Color.fromRGBO(27, 28, 30, 1),
      leadingWidth: 140.w,
      leading: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 2.w),
            child: SvgPicture.asset("assets/icons/youtube.svg", height: 33.h),
          ),
          Text(
            "YouTube",
            style: TextStyle(
              fontFamily: 'KenyanCoffee',
              fontSize: 26.sp
            ),
          )
        ],
      ),
      actions: [
        Row(
          children: [
            Icon(Icons.cast, size: 20.w,),
            SizedBox(width: 18.w),
            SizedBox(
              width: 40.w,
              child: Stack(
                children: [
                  Icon(Icons.notifications_none_outlined, size: 22.w,),
                  Positioned(
                    top: 0,
                    right: -2.w,
                    child: Container(
                      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w, bottom: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: const Text(
                        "7+",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 18.w),
            Icon(Icons.search, size: 22.w,),
            SizedBox(width: 18.w),
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15.r)
              ),
              child: Center(
                child: Text(
                  "J",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 20.sp
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
      ],
    );
  }
}