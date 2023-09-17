import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/core/usecase/usecase.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';
import 'package:yt_ui_clone/domain/usecases/get_local_yt_video.dart';
import 'package:yt_ui_clone/domain/usecases/get_yt_category_videos.dart';
import 'package:yt_ui_clone/domain/usecases/get_yt_video.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final GetYtVideosUseCase getYTVideosUseCase;
  final GetLocalYtVideoUseCase getLocalYtVideoUseCase;
  final GetYtCategoryVideos getYtCategoryVideos;

  HomeBloc({
    required this.getYTVideosUseCase,
    required this.getLocalYtVideoUseCase,
    required this.getYtCategoryVideos,
  }) : super(HomeLoadingState()) {
    on<AppStarted>(loadHomescreenHandler);
    on<HomeLoadEvent>(loadHomescreenHandler);
    on<HomeErrorEvent>(homeErrorEventHandler);

    // navigation event handlers
    on<NavigateToYtPlayer>(navigateToYtPlayerHandler);
    on<NavigateToHomePage>(navigateToHomePage);
  }

  FutureOr<void> loadHomescreenHandler(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    final dataState = await getYTVideosUseCase();

    if (dataState is DataSuccess) {
      emit(HomeSuccessState(videos: dataState.data!));
    } else {
      emit(HomeErrorState(error: dataState.error));
    }
  }

  FutureOr<void> homeErrorEventHandler(HomeErrorEvent event, Emitter<HomeState> emit) {
    emit(HomeErrorState(error: event.error));
  }

  FutureOr<void> navigateToYtPlayerHandler(NavigateToYtPlayer event, Emitter<HomeState> emit) async {
    //final Future<DataState<List<VideoEntity>>> localDbData = getLocalYtVideoUseCase();
    //final Future<DataState<List<VideoEntity>>> suggestionVideosData = getYtCategoryVideos(categoryId: event.videoCategorgId);

    emit(
      HomeVideoPlayer(
        activeVideo: event.activeVideo,
        getRecommendedVideosCallback: getYtCategoryVideos,
        videosList: state.videos!,
      )
    );
  }

  FutureOr<void> navigateToHomePage(NavigateToHomePage event, Emitter<HomeState> emit) {
    emit(HomeSuccessState(videos: state.videos!));
  }
}
