import 'package:json_annotation/json_annotation.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video_content_details.dart';

part 'video_content_details.g.dart';

@JsonSerializable()
class VideoContentDetailsModel extends VideoContentDetailsEntity {

  VideoContentDetailsModel({
    String? duration,
    String? definition,
    String? caption
  }): super(
    duration: duration,
    definition: definition,
    caption: caption
  );

  factory VideoContentDetailsModel.fromJson(Map<String, dynamic> json) => _$VideoContentDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoContentDetailsModelToJson(this);
}