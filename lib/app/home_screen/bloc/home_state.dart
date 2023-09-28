part of 'home_bloc.dart';

abstract class HomeState extends Equatable {

  final List<VideoEntity>? videos;
  final Exception? exception;

  const HomeState({
    this.videos,
    this.exception
  });

  @override
  List<Object?> get props => [videos, exception];
}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  const HomeSuccessState({required List<VideoEntity> videos}): super(videos: videos);
}

class HomeErrorState extends HomeState {
  const HomeErrorState({Exception? error}): super(exception: error);
}

class HomeVideoPlayer extends HomeState {
  final VideoEntity activeVideo;
  final Future<DataState<List<VideoEntity>>> recommendationVideos;

  const HomeVideoPlayer({
    required this.activeVideo,
    required this.recommendationVideos,
    required List<VideoEntity> videosList,
  }): super(videos: videosList);

  @override
  List<Object?> get props => [ activeVideo.videoId ];
}

// navigation states

class HomeNavigationState extends HomeState {}