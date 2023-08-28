import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yt_ui_clone/app/home_screen/bloc/home_bloc.dart';
import 'package:yt_ui_clone/core/constants/constants.dart';

class BottomNavBar extends StatelessWidget {
  final int? index;
  final double? navBarBottomPos;

  const BottomNavBar({
    super.key,
    this.index, 
    this.navBarBottomPos,
  });

  @override
  Widget build(BuildContext context) {

    NavBarItem currentActiveItem = NavBarItem.home;

    switch (index) {
      case 0:
        currentActiveItem = NavBarItem.home;
        break;
      case 1:
        currentActiveItem = NavBarItem.shorts;
        break;
      case 2:
        currentActiveItem = NavBarItem.add;
        break;
      case 3:
        currentActiveItem = NavBarItem.subscriptions;
        break;
      case 4:
        currentActiveItem = NavBarItem.library;
        break;
      default:
        currentActiveItem = NavBarItem.home;
        break;
    }

    return Positioned(
      bottom: navBarBottomPos ?? 0,
      left: 6,
      right: 6,
      child: Container(
        height: 66.h,
        margin: EdgeInsets.only(bottom: 20.h, left: 7.w, right: 7.w),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(27, 28, 30, 1),
          //color: Colors.black,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color.fromARGB(150, 247, 247, 247),
            width: 0,
          )
        ),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(context, Icons.home_filled, Icons.home_outlined, NavBarItem.home, currentActiveItem),
            _buildNavBarItem(context, Icons.bolt_rounded, Icons.bolt, NavBarItem.shorts, currentActiveItem),
            _buildNavBarItem(context, Icons.add_circle_rounded, Icons.add_circle_outline_rounded, NavBarItem.add, currentActiveItem),
            _buildNavBarItem(context, Icons.subscriptions_rounded, Icons.subscriptions_outlined, NavBarItem.subscriptions, currentActiveItem),
            _buildNavBarItem(context, Icons.video_collection_rounded, Icons.video_collection_outlined, NavBarItem.library, currentActiveItem),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData selectedIcon, IconData unSelectedIcon, NavBarItem item, NavBarItem currentActiveItem) {
    return GestureDetector(
      onTap: () => BlocProvider.of<HomeBloc>(context).add(NavigateToHomePage()),
      child: Icon(
        currentActiveItem == item ? selectedIcon : unSelectedIcon,
        color: currentActiveItem == item ? Colors.white : Colors.grey,
        size: 30,
      ),
    );
  }
}