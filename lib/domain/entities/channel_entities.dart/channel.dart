import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel_statistics.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel_thumbnails.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ChannelEntity {
  @Id()
  int id;
  @Index()
  final String? channelId;
  final String? title;
  final String? description;
  final String? url;
  
  final ToOne<ChannelStatisticsEntity> statistics = ToOne<ChannelStatisticsEntity>();

  @Backlink()
  final ToMany<ChannelThumbnail> thumbnails = ToMany<ChannelThumbnail>();

  @Backlink()
  final ToMany<VideoEntity> videos = ToMany<VideoEntity>();

  ChannelEntity({
    this.id = 0,
    this.channelId,
    this.title,
    this.description,
    this.url,
  });
}