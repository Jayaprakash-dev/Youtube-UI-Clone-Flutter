import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/core/usecase/usecase.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';
import 'package:yt_ui_clone/domain/repos/remote/video_repo.dart';


class GetYtVideosUseCase implements UseCase<DataState<List<VideoEntity>>, void> {
  final VideoRepo videoRepo;

  const GetYtVideosUseCase({required this.videoRepo});

  @override
  Future<DataState<List<VideoEntity>>> call({void categoryId}) async {
    return await videoRepo.getYtPopularVideos();
  }
}