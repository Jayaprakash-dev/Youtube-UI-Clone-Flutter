import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/core/usecase/usecase.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel.dart';
import 'package:yt_ui_clone/domain/repos/remote/channel_repo.dart';

class GetYtChannelUseCase implements UseCase<DataState<ChannelEntity>, String> {
  final ChannelRepo channelRepo;

  GetYtChannelUseCase({required this.channelRepo});

  @override
  Future<DataState<ChannelEntity>> call({String? categoryId}) async {
    return await channelRepo.getChannelDetails(id: categoryId ?? "");
  }
}