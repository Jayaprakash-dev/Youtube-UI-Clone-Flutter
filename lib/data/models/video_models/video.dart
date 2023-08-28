import 'package:yt_ui_clone/data/models/video_models/video_content_details.dart';
import 'package:yt_ui_clone/data/models/video_models/video_statistics.dart';
import 'package:yt_ui_clone/data/models/video_models/video_thumbnail.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';

// ignore: must_be_immutable
class VideoModel extends VideoEntity {

  VideoModel({
    final String? videoId,
    final String? videoType,
    final String? title,
    final String? channelId,
    final String? channelTitle,
    final String? desc,
    final String? categoryId,
    final String? lang,
    final DateTime? publishedAt,
    final List<String> ?tags,
  }): super(
    videoId: videoId,
    videoType: videoType,
    title: title,
    channelId: channelId,
    channelTitle: channelTitle,
    desc: desc,
    categoryId: categoryId,
    lang: lang,
    publishedAt: publishedAt,
    tags: tags,
  );

  factory VideoModel.fromJson(Map<String, dynamic> json) {

    final Map<String, dynamic> snippet = json['snippet'];
    final VideoStatisticsModel videoStatistics = VideoStatisticsModel.fromJson(json['statistics']);
    final VideoContentDetailsModel videoContentDetails = VideoContentDetailsModel.fromJson(json['contentDetails']);
    final List<VideoThumbnailModel> thumbnails = [];

    for (final entry in (snippet['thumbnails'] as Map<String, dynamic>).entries) {
      VideoThumbnailModel thumbnail =  VideoThumbnailModel.fromJson({
        'type': entry.key,
        'url': entry.value['url'],
        'width': entry.value['width'],
        'height': entry.value['height']
      });
      thumbnails.add(thumbnail);
    }

    final VideoModel video = VideoModel(
      videoId: json['id'] as String?,
      title: snippet['title'] as String?,
      channelId: snippet['channelId'] as String?,
      channelTitle: snippet['channelTitle'] as String?,
      desc: snippet['description'] as String?,
      categoryId: snippet['categoryId'] as String?,
      lang: snippet['defaultLanguage'] as String?,
      publishedAt: snippet['publishedAt'] == null
        ? null
        : DateTime.parse(snippet['publishedAt'] as String),
      tags: (snippet['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

    video.statistics.target = videoStatistics;
    videoStatistics.video.target = video;

    video.contentDetails.target = videoContentDetails;
    videoContentDetails.video.target = video;

    for (final VideoThumbnailModel thumbnail in thumbnails) {
      thumbnail.video.target = video;
      video.thumbnails.add(thumbnail);
    }

    return video;
  }

  factory VideoModel.fromEntity(VideoEntity entity) {
    return VideoModel(
      videoId: entity.videoId,
      videoType: entity.videoType,
      title: entity.title,
      channelId: entity.channelId,
      channelTitle: entity.channelTitle,
      desc: entity.desc,
      categoryId: entity.categoryId,
      lang: entity.lang,
      publishedAt: entity.publishedAt,
      tags: entity.tags,
    );
  }

  @override
  String toString() {
    return '\n video id: $videoId \n title: $title \n channel title: $channelTitle';
  }
}