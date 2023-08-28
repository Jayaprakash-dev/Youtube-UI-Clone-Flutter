import 'package:json_annotation/json_annotation.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ChannelStatisticsEntity {

  final double _toK = 1000;
  final double _toM = (1000*1000);
  final double _toB = (1000*1000*1000);
  
  @JsonKey(includeFromJson: false, includeToJson: false)
  @Id()
  int id;

  final String viewCount;
  final String subscriberCount;
  final String videoCount;

  final ToOne<ChannelEntity> channel = ToOne<ChannelEntity>();

  ChannelStatisticsEntity({
    this.id = 0,
    required this.viewCount,
    required this.subscriberCount, 
    required this.videoCount,
  });

  String parseCount(String val) {

    double valAsNum = double.parse(val);

    if (val.length <= 6) {
      valAsNum /= _toK;
      String valStr = valAsNum.toStringAsFixed(1);

      return valStr.endsWith('0')
        ? '${valStr.substring(0, valStr.length-2)}k'
        : '${valAsNum.toStringAsFixed(1)}K';
    } else if (val.length <= 9) {
      valAsNum /= _toM;
      String valStr = valAsNum.toStringAsFixed(1);

      return valStr.endsWith('0')
        ? '${valStr.substring(0, valStr.length-2)}M'
        : '${valAsNum.toStringAsFixed(1)}M';
    } else {
      valAsNum /= _toB;
      String valStr = valAsNum.toStringAsFixed(1);
      
      return valStr.endsWith('0')
        ? '${valStr.substring(0, valStr.length-2)}B'
        : '${valAsNum.toStringAsFixed(1)}B';
    }
  }
}