import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/core/usecase/usecase.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';
import 'package:yt_ui_clone/domain/repos/local/local_datastore.dart';

class GetLocalYtVideoUseCase implements UseCase<DataState<List<VideoEntity>>, void> {

  final LocalDataStore localRepo;

  const GetLocalYtVideoUseCase({ required this.localRepo });

  @override
  Future<DataState<List<VideoEntity>>> call({void categoryId}) async {
    return await localRepo.getAllVideo();
  }
}