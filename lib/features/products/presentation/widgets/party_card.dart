/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter/material.dart';
import '../../domain/entities/party.dart';

class PartyCard extends StatelessWidget {
  final Party party;

  const PartyCard({super.key, required this.party});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageViewer(images: party.images),
        const SizedBox(height: 10,),
        Text(party.title,textAlign: TextAlign.center,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
        const SizedBox(height: 20)
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;

  const _ImageViewer({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: FadeInImage(
        fit: BoxFit.cover,
        height: 250,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
        image: NetworkImage(images.first),
        placeholder: const AssetImage('assets/images/fondo_2.png'),
      ),
    );
  }
}
