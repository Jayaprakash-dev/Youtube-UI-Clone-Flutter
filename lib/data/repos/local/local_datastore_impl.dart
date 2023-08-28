import 'dart:async';

import 'package:objectbox/objectbox.dart';
import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';
import 'package:yt_ui_clone/domain/repos/local/local_datastore.dart';

class LocalDataStoreImpl implements LocalDataStore {

  final Store store;

  LocalDataStoreImpl({
    required this.store,
  });
  
  @override
  Future<void> deleteVideo({required String id}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllVideos() async {
    store.box<VideoEntity>().removeAllAsync();
    store.box<ChannelEntity>().removeAllAsync();
  }

  @override
  Future<DataState<VideoEntity>> getVideo({required String id}) {
    throw UnimplementedError();
  }
  
  @override
  Future<DataState<List<VideoEntity>>> getAllVideo() async {
    Query query = store.box<VideoEntity>().query().build();
    List<VideoEntity> videos = query.find() as List<VideoEntity>;
    query.close();

    if (videos.isEmpty) return DataException(Exception());
    
    return DataSuccess(videos);
  }
}