import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';


abstract interface class VideoRepo {
  Future<DataState<List<VideoEntity>>> getYtPopularVideos();

  Future<DataState<List<VideoEntity>>> getYtVideosByCategory({required String categoryId});
}