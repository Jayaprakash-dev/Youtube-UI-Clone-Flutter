part of 'home_bloc.dart';

abstract class HomeState extends Equatable {

  final Future<DataState<List<VideoEntity>>>? videos;
  final Exception? exception;

  const HomeState({
    this.videos,
    this.exception
  });

  @override
  List<Object?> get props => [videos, exception];
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeSuccessState extends HomeState {
  const HomeSuccessState({required Future<DataState<List<VideoEntity>>> videos}): super(videos: videos);
}

class HomeErrorState extends HomeState {
  const HomeErrorState({Exception? error}): super(exception: error);
}

class HomeVideoPlayer extends HomeState {
  final VideoEntity activeVideo;
  final Future<DataState<List<VideoEntity>>> suggestionVideosList;

  const HomeVideoPlayer({
    required this.activeVideo,
    required this.suggestionVideosList,
    required Future<DataState<List<VideoEntity>>> videosList,
  }): super(videos: videosList);
}

// navigation states

class HomeNavigationState extends HomeState {}