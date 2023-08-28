import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:yt_ui_clone/domain/entities/thumbnail.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';

@Entity()
base class VideoThumbnail extends Thumbnail {

  @JsonKey(includeFromJson: false, includeToJson: false)
  @Id()
  int id;

  @Property()
  final String type;

  @Property()
  final String url;

  @Property()
  final int width;

  @Property()
  final int height;

  final ToOne<VideoEntity> video = ToOne<VideoEntity>();

  VideoThumbnail({
    this.id = 0,
    required this.type,
    required this.url,
    required this.width,
    required this.height,
  }): super(
    type: type,
    url: url,
    width: width,
    height: height
  );
}