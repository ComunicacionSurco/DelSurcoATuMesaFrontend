/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:surco/features/auth/presentation/providers/auth_provider.dart';
import 'package:surco/features/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({
    super.key,
    required this.scaffoldKey,
  });

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  Future<void> _launchURLFacebook(String url) async {
    final Uri uri = Uri.https('faceboof.com', url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  Future<void> _launchURLTiktok(String url) async {
    final Uri uri = Uri.https('tiktok.com', url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.https(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 25;
    final textStyles = Theme.of(context).textTheme;

    return NavigationDrawer(elevation: 1, children: [
      Padding(
        padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
        child: Text('Usuario', style: textStyles.titleMedium),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
        child: Text('', style: textStyles.titleSmall),
      ),
      NavigationDrawerDestination(
        icon: IconButton(
            onPressed: () {
              context.push('/');
            },
            icon: const Icon(Icons.home)),
        label: const Text('Inicio'),
      ),

      NavigationDrawerDestination(
        icon: IconButton(
            onPressed: () {
              context.push('/videos');
            },
            icon: const Icon(Icons.video_camera_back)),
        label: const Text('Videos'),
      ),

      NavigationDrawerDestination(
        icon: IconButton(
            onPressed: () {
              _launchURL("surcooaxaca.org");
            },
            icon: const Icon(Icons.web_asset)),
        label: const Text('Web'),
      ),
      NavigationDrawerDestination(
        icon: IconButton(
            onPressed: () {
              _launchURLFacebook('surcooaxac');
            },
            icon: const Icon(Icons.facebook)),
        label: const Text('Facebook'),
      ),
      NavigationDrawerDestination(
        icon: IconButton(
            onPressed: () {
              _launchURLTiktok('@surcooaxaca');
            },
            icon: const Icon(Icons.tiktok)),
        label: const Text('Tiktok'),
      ),


    const SizedBox(height: 30,),
      const Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
      const Padding(
        padding: EdgeInsets.fromLTRB(28, 20, 28, 10),
        child: Divider(),
      ),

        

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomFilledButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            text: 'Cerrar sesión'),
      ),
    ]);
  }
}
