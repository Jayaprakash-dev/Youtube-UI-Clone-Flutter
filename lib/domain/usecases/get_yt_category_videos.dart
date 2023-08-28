import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/core/usecase/usecase.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';
import 'package:yt_ui_clone/domain/repos/remote/video_repo.dart';

class GetYtCategoryVideos implements UseCase<DataState<List<VideoEntity>>, String> {
  final VideoRepo videoRepo;

  const GetYtCategoryVideos({required this.videoRepo});
  
  @override
  Future<DataState<List<VideoEntity>>> call({String? categoryId}) async {
    return await videoRepo.getYtVideosByCategory(categoryId: categoryId!);
  }
}