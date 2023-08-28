import 'package:json_annotation/json_annotation.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class VideoContentDetailsEntity {

  @JsonKey(includeFromJson: false, includeToJson: false)
  @Id()
  int id;

  final String? duration;
  final String? definition;
  final String? caption;

  final ToOne<VideoEntity> video = ToOne<VideoEntity>();

  VideoContentDetailsEntity({
    this.id = 0,
    this.duration,
    this.definition,
    this.caption,
  });

  String? get videoDuration {
    final RegExp durationMatchPattern = RegExp(r'PT(\d*H)?(\d*M)?(\d*S)?');
    final Match match = durationMatchPattern.firstMatch(duration!)!;

    List<String?> durationInList = match.groups([1,2,3]);

    return parseDuration(durationInList);
  }

  String? parseDuration(List<String?> durationInList) {
    String parsedDuration = '';
    
    for (int i = 0; i < durationInList.length; i++) {
      String? current = durationInList[i];

      if (current == null) continue;

      current = current.substring(0, current.length-1);
      parsedDuration += parseCurrentSegment(str: current, isSec: i == durationInList.length-1 ? true : false);
    }

    return  parsedDuration.isEmpty ? null : (parsedDuration.length <= 2 ? '0:$parsedDuration' : parsedDuration);
  }

  String parseCurrentSegment({String? str, bool? isSec}) {
    if (str!.length == 1) {
      return isSec! ? '0$str' : '$str:';
    }
    return isSec! ? str : '$str:';
  }
}