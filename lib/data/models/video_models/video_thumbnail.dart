import 'package:json_annotation/json_annotation.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video_thumbnail.dart';

part 'video_thumbnail.g.dart';

@JsonSerializable()
final class VideoThumbnailModel extends VideoThumbnail {
  VideoThumbnailModel({
    required String type,
    required String url,
    required int width,
    required int height
  }):super(
    type: type,
    url: url,
    width: width,
    height: height
  );

  factory VideoThumbnailModel.fromJson(Map<String, dynamic> json) => _$VideoThumbnailModelFromJson(json);
}