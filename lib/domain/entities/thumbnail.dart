import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
base class Thumbnail {

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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @Property(type: PropertyType.byteVector)
  Uint8List? _imageBytesData;

  Thumbnail({
    this.id = 0,
    required this.type,
    required this.url,
    required this.width,
    required this.height,
  });

  Future<Uint8List> getImageBytes() async {
    if (_imageBytesData != null) return _imageBytesData!;
    
    ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    _imageBytesData = data.buffer.asUint8List();
    return _imageBytesData!;
  }
}