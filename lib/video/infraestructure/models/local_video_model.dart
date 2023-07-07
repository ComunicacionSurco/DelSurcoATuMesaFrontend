/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:surco/video/domain/entitie/video_post.dart';

class LocalVideoModel {
  final String name;
  final String videoUrl;
  final int views;
  final int likes;

  LocalVideoModel(
      {required this.name,
      required this.videoUrl,
      this.views = 0,
      this.likes = 0});

  factory LocalVideoModel.fromJson(Map<String, dynamic> json) =>
      LocalVideoModel(
          name: json["name"] ?? "No name",
          videoUrl: json["videoUrl"],
          views: json["views"] ?? "0",
          likes: json["likes"] ?? "0");

  VideoPost toVideoPostEntity() =>
      VideoPost(caption: name, videoUrl: videoUrl, likes: likes, views: views);
}
