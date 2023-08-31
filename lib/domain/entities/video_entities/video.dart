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

  String formatPublishedDate() {

    Duration durationDiff = DateTime.now().difference(publishedAt!);

    int secsDiff = durationDiff.inSeconds;
    if (secsDiff > 0 && secsDiff < 60) {
      return secsDiff == 1 ? '1 second ago' : '$secsDiff seconds ago';
    }

    int minsDiff = durationDiff.inMinutes;
    if (minsDiff > 0 && minsDiff < 60) {
      return minsDiff == 1 ? '1 minute ago' : '$minsDiff minutes ago';
    }
    
    int hoursDiff = durationDiff.inHours;
    if (hoursDiff > 0 && hoursDiff < 24) {
        return hoursDiff == 1 ? '1 hour ago' : '$hoursDiff hours ago';
    }

    int daysDiff = durationDiff.inDays;

    if (daysDiff >= 365) {
      int yearsDiff = daysDiff ~/ 365;
      return (daysDiff == 365 || daysDiff == 366)? '1 year ago' : '$yearsDiff years ago';
    }
    
    if (daysDiff > 29) {
      int monthsDiff = daysDiff ~/ 30.417;
      return (daysDiff == 30 || daysDiff == 31) ? '1 month ago' : '$monthsDiff months ago';
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