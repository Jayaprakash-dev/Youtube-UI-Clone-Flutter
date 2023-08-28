import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel.dart';

abstract interface class ChannelRepo {
  Future<DataState<ChannelEntity>> getChannelDetails({required String id});
}