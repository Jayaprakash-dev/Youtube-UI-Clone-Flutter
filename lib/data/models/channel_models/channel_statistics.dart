import 'package:json_annotation/json_annotation.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel_statistics.dart';

part 'channel_statistics.g.dart';

@JsonSerializable()
class ChannelStatisticsModel extends ChannelStatisticsEntity {
  ChannelStatisticsModel(
    final String viewCount,
    final String subscriberCount,
    final String videoCount
  ): super(
    viewCount: viewCount,
    subscriberCount: subscriberCount,
    videoCount: videoCount
  );

  factory ChannelStatisticsModel.fromJson(Map<String, dynamic> json) => _$ChannelStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelStatisticsModelToJson(this);
}