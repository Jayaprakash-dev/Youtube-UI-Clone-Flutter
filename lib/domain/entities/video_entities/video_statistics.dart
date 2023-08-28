import 'package:json_annotation/json_annotation.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class VideoStatisticsEntity {

  @JsonKey(includeFromJson: false, includeToJson: false)
  @Id()
  int id;

  final double _toK = 1000;
  final double _toM = (1000*1000);
  final double _toB = (1000*1000*1000);

  final String? viewCount;
  final String? likeCount;
  final String? commentCount;

  final ToOne<VideoEntity> video = ToOne<VideoEntity>();

  VideoStatisticsEntity({
    this.id = 0,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount
  });

  String get parseViewCount {
    if (viewCount == null) return '0';

    double viewCountParsed = double.parse(viewCount!);

    if (viewCount!.length <= 6) {
      viewCountParsed /= _toK;
      String viewCountStr = viewCountParsed.toStringAsFixed(1);
      return viewCountStr.endsWith('0')
        ? '${viewCountStr.substring(0, viewCountStr.length-2)}k'
        : '${viewCountParsed.toStringAsFixed(1)}K';
    } else if (viewCount!.length <= 9) {
      viewCountParsed /= _toM;
      String viewCountStr = viewCountParsed.toStringAsFixed(1);
      return viewCountStr.endsWith('0')
        ? '${viewCountStr.substring(0, viewCountStr.length-2)}M'
        : '${viewCountParsed.toStringAsFixed(1)}M';
    } else {
      viewCountParsed /= _toB;
      String viewCountStr = viewCountParsed.toStringAsFixed(1);
      return viewCountStr.endsWith('0')
        ? '${viewCountStr.substring(0, viewCountStr.length-2)}B'
        : '${viewCountParsed.toStringAsFixed(1)}B';
    }
  }
}