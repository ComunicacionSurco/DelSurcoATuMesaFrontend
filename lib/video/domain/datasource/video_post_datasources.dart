/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:surco/video/domain/entitie/video_post.dart';

abstract class VideoPostDatasource{

  Future<List<VideoPost>> getTrendingVideosByPage (int page);
  Future<List<VideoPost>> getFavoriteVideosByUser (String userID);

}