import 'package:yt_ui_clone/data/models/channel_models/channel_thumbnail.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel.dart';

import 'channel_statistics.dart';

class ChannelModel extends ChannelEntity {
  ChannelModel ({
    final String? id,
    final String? title,
    final String? description,
    final String? url,
    final Map<String, dynamic>? thumbnails,
  }): super(
    channelId: id,
    title: title,
    description: description,
    url: url,
  );

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    final ChannelStatisticsModel statistics = ChannelStatisticsModel.fromJson(json['statistics']);
    final List<ChannelThumbnailModel> thumbnails = [];

    for (final entry in (json['snippet']['thumbnails'] as Map<String, dynamic>).entries) {
      ChannelThumbnailModel thumbnail =  ChannelThumbnailModel.fromJson({
        'type': entry.key,
        'url': entry.value['url'],
        'width': entry.value['width'],
        'height': entry.value['height']
      });
      thumbnails.add(thumbnail);
    }

    final ChannelModel channel = ChannelModel(
      id: json['id'],
      title: json['snippet']['title'],
      description: json['snippet']['description'],
      thumbnails: json['snippet']['thumbnails'],
    );

    channel.statistics.target = statistics;
    statistics.channel.target = channel;

    for (ChannelThumbnailModel thumbnail in thumbnails) {
      channel.thumbnails.add(thumbnail);
      thumbnail.channel.target = channel;
    }

    return channel;
  }
}