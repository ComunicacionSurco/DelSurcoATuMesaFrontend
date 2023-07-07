/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:surco/video/domain/datasource/video_post_datasources.dart';
import 'package:surco/video/domain/entitie/video_post.dart';
import 'package:surco/video/domain/repositories/video_post_repository.dart';

class VideoPostsRepositoryImpl implements VideoPostRepository{
  final VideoPostDatasource videoDataSource;

  VideoPostsRepositoryImpl({ required this.videoDataSource});


  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) {
    return videoDataSource.getTrendingVideosByPage(page);
  }

}