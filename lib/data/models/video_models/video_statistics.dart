import 'package:json_annotation/json_annotation.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video_statistics.dart';

part 'video_statistics.g.dart';

@JsonSerializable()
class VideoStatisticsModel extends VideoStatisticsEntity {

  VideoStatisticsModel({
    required String? viewCount,
    required String? likeCount,
    required String? commentCount
  }):super(
    viewCount: viewCount,
    likeCount: likeCount,
    commentCount: commentCount
  );

  factory VideoStatisticsModel.fromJson(Map<String, dynamic> json) => _$VideoStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoStatisticsModelToJson(this);

  @override
  String toString() {
    return '\n view count: $viewCount \n like count: $likeCount \n comment count: $commentCount';
  }
}