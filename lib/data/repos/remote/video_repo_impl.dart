import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yt_ui_clone/core/constants/constants.dart';
import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/core/env/env.dart';
import 'package:yt_ui_clone/data/models/video_models/video.dart';
import 'package:yt_ui_clone/domain/entities/video_entities/video.dart';
import 'package:yt_ui_clone/domain/repos/local/local_datastore.dart';
import 'package:yt_ui_clone/domain/repos/remote/channel_repo.dart';
import 'package:yt_ui_clone/domain/repos/remote/video_repo.dart';
import 'package:yt_ui_clone/objectbox.g.dart';
import 'package:yt_ui_clone/service_locator.dart';


class VideoRepoImpl implements VideoRepo {

  final Dio dio;
  final Store store;

  VideoRepoImpl({
    required this.dio,
    required this.store,
  });

  @override
  Future<DataState<List<VideoEntity>>> getYtPopularVideos() async {
    try {

      services<LocalDataStore>().deleteAllVideos();

      final Map<String, dynamic> queryParam = {
        'part': 'snippet,statistics,contentDetails',
        'chart': 'mostPopular',
        'maxResults': 20,
        'key': Env.API_KEY,
      };

      Response dioResult = await dio.get(
        BASE_VIDEO_URL,
        queryParameters: queryParam,
        //options: Options(responseType: ResponseType.stream)
      );

      if (dioResult.statusCode != HttpStatus.ok || dioResult.data == null) return sendErrorReport(dioResult);

      List<VideoEntity> videos = [];
      final channelRepo = services<ChannelRepo>();

      for (Map<String, dynamic> element in dioResult.data['items'] as List<dynamic>) {

        final VideoModel video = VideoModel.fromJson(element);

        final res = await channelRepo.getChannelDetails(id: element['snippet']['channelId']);
        
        if (res is DataException) return DataException(res.error!);

        // linking channel to video store in db
        video.channel.target = res.data;
        res.data!.videos.add(video);
        videos.add(video);
      }

      store.runInTransactionAsync( // runs in separate worker isolate(thread)
        TxMode.write,
        (store, videos) {
          final Box<VideoEntity> storeBox = store.box<VideoEntity>();
          for (VideoEntity video in videos) {
            final query = storeBox.query(VideoEntity_.videoId.equals(video.videoId!)).build();
            final res = query.find();

            if (res.isNotEmpty) continue;

            storeBox.put(video);
            query.close();
          }
        },
        videos
      );

      return DataSuccess(videos);
    } on DioException catch (e) {
      return DataException(e);
    } on Exception catch (e) {
      return DataException(e);
    }
  }

  DataState<List<VideoEntity>> sendErrorReport(Response res) {
    return DataException(
      DioException(
        error: res.statusMessage, 
        response: res,
        requestOptions: res.requestOptions,
        type: DioExceptionType.badResponse,
      )
    );
  }
  
  @override
  Future<DataState<List<VideoEntity>>> getYtVideosByCategory({required String categoryId}) async {

    try {

      final Map<String, dynamic> queryParam = {
        'part': 'snippet,statistics,contentDetails',
        'chart': 'mostPopular',
        'maxResults': 15,
        'key': Env.API_KEY,
        'videoCategoryId': categoryId
      };

      Response dioResult = await dio.get(
        BASE_VIDEO_URL,
        queryParameters: queryParam,
        //options: Options(responseType: ResponseType.stream)
      );

      if (dioResult.statusCode != HttpStatus.ok || dioResult.data == null) return sendErrorReport(dioResult);

      List<VideoEntity> videos = [];

      if (dioResult.statusCode == HttpStatus.ok && dioResult.data != null) {
        final channelRepo = services<ChannelRepo>();
        for (Map<String, dynamic> element in dioResult.data['items'] as List<dynamic>) {

          final VideoModel video = VideoModel.fromJson(element);

          final res = await channelRepo.getChannelDetails(id: element['snippet']['channelId']);
          
          if (res is DataException) return DataException(res.error!);

          // linking channel to video store in db
          video.channel.target = res.data;
          res.data!.videos.add(video);
          
          videos.add(video);
        }
      }
      return DataSuccess(videos);
    } on DioException catch (e) {
      return DataException(e);
    } on Exception catch (e) {
      return DataException(e);
    }
  }
}
