import 'package:json_annotation/json_annotation.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel_thumbnails.dart';

part 'channel_thumbnail.g.dart';

@JsonSerializable()
final class ChannelThumbnailModel extends ChannelThumbnail {
  
  ChannelThumbnailModel({
    required String type,
    required String url,
    required int width,
    required int height
  }): super(
    type: type,
    url: url,
    width: width,
    height: height
  );

  factory ChannelThumbnailModel.fromJson(Map<String, dynamic> json) => _$ChannelThumbnailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelThumbnailModelToJson(this);
}