import 'package:yt_ui_clone/core/data/data_state.dart';

import '../../entities/video_entities/video.dart';

abstract interface class LocalDataStore {
  Future<DataState<VideoEntity>> getVideo({required String id});

  Future<DataState<List<VideoEntity>>> getAllVideo();

  Future<void> deleteAllVideos();

  Future<void> deleteVideo({required String id});
}