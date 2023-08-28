import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yt_ui_clone/core/constants/constants.dart';
import 'package:yt_ui_clone/core/data/data_state.dart';
import 'package:yt_ui_clone/core/env/env.dart';
import 'package:yt_ui_clone/data/models/channel_models/channel.dart';
import 'package:yt_ui_clone/domain/entities/channel_entities.dart/channel.dart';
import 'package:yt_ui_clone/domain/repos/remote/channel_repo.dart';


class ChannelRepoImpl implements ChannelRepo {

  final Dio dio;

  ChannelRepoImpl({
    required this.dio,
  });

  @override
  Future<DataState<ChannelEntity>> getChannelDetails({required String id}) async {
    
    try {

      final Map<String, dynamic> queryParam = {
        'part': 'snippet,statistics,contentDetails',
        'id': id,
        'key': Env.API_KEY,
      };

      final Response res = await dio.get(
        BASE_CHANNEL_URL,
        queryParameters: queryParam
      );

      if (res.statusCode == HttpStatus.ok && res.data != null) {
        return DataSuccess(ChannelModel.fromJson(res.data['items'][0]));
      }

      return DataException(
        DioException(
          error: res.statusMessage,
          response: res,
          requestOptions: res.requestOptions,
          type: DioExceptionType.badResponse
        )
      );
    } on DioException catch (e) {
      return DataException(e);
    } on Exception catch (e) {
      return DataException(e);
    }
  }
}