part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class AppStarted extends HomeEvent {}

class HomeLoadEvent extends HomeEvent {}

class HomeErrorEvent extends HomeEvent {
  final Exception error;

  HomeErrorEvent({
    required this.error,
  });
}

class HomeNavigationEvent extends HomeEvent {}

class NavigateToYtPlayer extends HomeNavigationEvent {
  final VideoEntity activeVideo;
  final String videoCategorgId;

  NavigateToYtPlayer({
    required this.activeVideo,
    required this.videoCategorgId,
  });
}

class NavigateToHomePage extends HomeNavigationEvent {
  final List<VideoEntity>? videos;

  NavigateToHomePage({
    this.videos,
  });
}