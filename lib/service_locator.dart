import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yt_ui_clone/app/home_screen/bloc/home_bloc.dart';
import 'package:yt_ui_clone/data/repos/local/local_datastore_impl.dart';
import 'package:yt_ui_clone/data/repos/remote/channel_repo_impl.dart';
import 'package:yt_ui_clone/data/repos/remote/video_repo_impl.dart';
import 'package:yt_ui_clone/domain/repos/local/local_datastore.dart';
import 'package:yt_ui_clone/domain/repos/remote/channel_repo.dart';
import 'package:yt_ui_clone/domain/repos/remote/video_repo.dart';
import 'package:yt_ui_clone/domain/usecases/get_local_yt_video.dart';
import 'package:yt_ui_clone/domain/usecases/get_yt_category_videos.dart';
import 'package:yt_ui_clone/domain/usecases/get_yt_channel.dart';
import 'package:yt_ui_clone/domain/usecases/get_yt_video.dart';
import 'package:yt_ui_clone/objectbox.g.dart';


final GetIt services = GetIt.instance;

void loadDependencies() {
  // HTTP client
  services.registerSingleton<Dio>(
    Dio(),
    dispose: (param) => param.close()
  );

  // shared preferences && persistent storage
  services.registerSingletonAsync<Store>(
    () async {
      final appDocDir = await getApplicationDocumentsDirectory();
      return Store(
        getObjectBoxModel(),
        directory: path.join(appDocDir.path, 'objectBox'),
      );
    },
    dispose: (param) async {
      // ignore: avoid_print
      print('Deleting db file');
      Directory appDocsDir = await getApplicationDocumentsDirectory();
      final file = File(path.join(appDocsDir.path, 'objectbox'));
      await file.delete();

      param.close();
    }
  );

  services.registerLazySingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance()
  );

  // repo objects
  services.registerSingletonWithDependencies<VideoRepo>(
    () => VideoRepoImpl(
      dio: services<Dio>(),
      store: services<Store>(),
    ),
    dependsOn: [ Store ]
  );
  services.registerLazySingleton<ChannelRepo>(() => ChannelRepoImpl(dio: services<Dio>()));
  services.registerLazySingleton<LocalDataStore>( () => LocalDataStoreImpl(store: services<Store>()) );


  // usecase objects
  services.registerSingletonWithDependencies<GetYtVideosUseCase>(
    () => GetYtVideosUseCase(videoRepo: services()),
    dependsOn: [ VideoRepo ]
  );
  services.registerLazySingleton<GetYtChannelUseCase>( () => GetYtChannelUseCase(channelRepo: services()) );
  services.registerLazySingleton<GetLocalYtVideoUseCase>(
    () => GetLocalYtVideoUseCase(localRepo: services()),
  );
  services.registerSingletonWithDependencies<GetYtCategoryVideos>(
    () => GetYtCategoryVideos(videoRepo: services()),
    dependsOn: [ VideoRepo ]
  );

  // bloc objects
  services.registerFactory<HomeBloc>(
    () => HomeBloc(getYTVideosUseCase: services(), getLocalYtVideoUseCase: services(), getYtCategoryVideos: services()),
  );
}
