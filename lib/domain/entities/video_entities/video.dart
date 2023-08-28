import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video_content_details.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video_statistics.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video_thumbnail.dart';

@Entity()
// ignore: must_be_immutable,
class VideoEntity extends Equatable {

  final double _toK = 1000;
  final double _toM = (1000*1000);
  final double _toB = (1000*1000*1000);

  @Id()
  int id;

  @Index() @Unique()
  final String? videoId;

  final String? videoType;
  final String? title;
  final String? channelId;
  final String? channelTitle;
  final String? desc;
  final String? categoryId;
  final String? lang;

  @Property(type: PropertyType.date)
  final DateTime? publishedAt;
  
  final List<String>? tags;
  final ToOne<VideoStatisticsEntity> statistics = ToOne<VideoStatisticsEntity>();
  final ToOne<VideoContentDetailsEntity> contentDetails = ToOne<VideoContentDetailsEntity>();
  final ToOne<ChannelEntity> channel = ToOne<ChannelEntity>();

  @Backlink()
  final ToMany<VideoThumbnail> thumbnails = ToMany<VideoThumbnail>();

  Map<String, int>? _dateDiff;

  VideoEntity({
    this.id = 0,
    this.videoId,
    this.videoType,
    this.title,
    this.channelId,
    this.channelTitle,
    this.desc,
    this.categoryId,
    this.lang,
    this.publishedAt,
    this.tags,
  });

  Map<String, int> get publishedDateDiff {
    if (_dateDiff != null) return _dateDiff!;

    int publishedYear = publishedAt!.year;
    int publishedMonth = publishedAt!.month;
    int publishedDay = publishedAt!.day;
    
    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;
    int currentMonth = currentDate.month;
    int currentDay = currentDate.day;

    int yearsDiff = currentYear - publishedYear;

    if (publishedMonth == DateTime.february && publishedDay > 27) {
      publishedMonth++;
    } else if (publishedDay >= 30) {
      publishedMonth++;
    }

    int numOfDays = 0;
    int numOfMonths = 0;
    int numOfHours = 0;
    int numOfMins = 0;
    int numOfSecs = 0;
    
    int start = publishedMonth;
    int end = currentMonth;
    while (start < end || publishedYear != currentYear) {

      if (start == 2) {
        if (isLeafyear(publishedYear)) {
          numOfDays += 29;
        } else {
          numOfDays += 28;
        }
      } else if (start % 2 != 0) {
          numOfDays += 31;
      } else {
        numOfDays += 30;
      }

      numOfMonths++;
      start++;

      if (start == 13) {
        start = 0;
        publishedYear++;
      }
    }

    // if numOfDay == 0, then current month == published month && current year == published year
    if (numOfDays == 0) {
      numOfDays = currentDay - publishedDay;
    }

    if (numOfDays == 0) {
      numOfHours = currentDate.toLocal().hour - publishedAt!.toLocal().hour;
      numOfMins = currentDate.toLocal().minute - publishedAt!.toLocal().minute;
      numOfSecs = currentDate.toLocal().second - publishedAt!.toLocal().second;
    }

    _dateDiff = {
      'yearsDiff': yearsDiff,
      'monthsDiff': numOfMonths,
      'daysDiff': numOfDays,
      'hoursDiff': numOfHours,
      'minsDiff': numOfMins,
      'secsDiff': numOfSecs,
    };

    return _dateDiff!;
  }

  bool isLeafyear(int year) {
    if ( (year % 400 == 0) || (year % 100 != 0 && year % 4 == 0) ) return true;
    return false;
  }

  String parsePublishedDate() {

    final Map<String, dynamic> publishedDateDiff = this.publishedDateDiff;

    int yearsDiff = publishedDateDiff['yearsDiff']!;
    int monthsDiff = publishedDateDiff['monthsDiff']!;
    int daysDiff = publishedDateDiff['daysDiff']!;
    
    if (daysDiff == 0) {
      int hoursDiff = publishedDateDiff['hoursDiff']!;
      if (hoursDiff > 0) {
        return hoursDiff == 1 ? '1 hour ago' : '$hoursDiff hours ago';
      }

      int minsDiff = publishedDateDiff['minsDiff']!;
      if (minsDiff > 0) {
        return minsDiff == 1 ? '1 minute ago' : '$minsDiff minutes ago';
      }

      int secsDiff = publishedDateDiff['secsDiff']!;
      if (secsDiff > 0) {
        return secsDiff == 1 ? '1 second ago' : '$secsDiff seconds ago';
      }
    }

    if (yearsDiff > 0) {
      return yearsDiff == 1 ? '1 year ago' : '$yearsDiff years ago';
    }
    
    if (monthsDiff > 0) {
      return monthsDiff == 1 ? '1 month ago' : '$monthsDiff months ago';
    }

    if (daysDiff < 7) {
      return daysDiff == 1 ? '1 day ago' : '$daysDiff days ago';
    } else if (daysDiff < 14) {
      return '1 week ago';
    } else if (daysDiff < 21) {
      return '2 weeks ago';
    } else if (daysDiff < 27) {
      return '3 weeks ago';
    } else {
      return '4 weeks ago';
    }
  }

  String parseCount(String val) {

    double valAsNum = double.parse(val);

    if (val.length <= 6) {
      valAsNum /= _toK;
      String valStr = valAsNum.toStringAsFixed(1);

      return valStr.endsWith('0')
        ? '${valStr.substring(0, valStr.length-2)}k'
        : '${valAsNum.toStringAsFixed(1)}K';
    } else if (val.length <= 9) {
      valAsNum /= _toM;
      String valStr = valAsNum.toStringAsFixed(1);

      return valStr.endsWith('0')
        ? '${valStr.substring(0, valStr.length-2)}M'
        : '${valAsNum.toStringAsFixed(1)}M';
    } else {
      valAsNum /= _toB;
      String valStr = valAsNum.toStringAsFixed(1);
      
      return valStr.endsWith('0')
        ? '${valStr.substring(0, valStr.length-2)}B'
        : '${valAsNum.toStringAsFixed(1)}B';
    }
  }
  
  @override
  List<Object?> get props => [ videoId ];
}