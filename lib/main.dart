/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surco/config/config.dart';
import 'package:surco/video/infraestructure/datasources/local_video_datasource_impl.dart';
import 'package:surco/video/infraestructure/repositories/video_post_repository_impl.dart';
import 'package:surco/video/presentation/providers/discover_provider.dart';

void main() async {
  await Environment.initEnvironment();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);
    final VideoPostRepository = VideoPostsRepositoryImpl(videoDataSource: LocalVideoDatasource());

    return provider.MultiProvider(
        providers: [
            provider.ChangeNotifierProvider(create: (_) => DiscoverProvider(videoPostRepository: VideoPostRepository)..loadNextPage())
        ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        theme: AppTheme().getTheme(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
