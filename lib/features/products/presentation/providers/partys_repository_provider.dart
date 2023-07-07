/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surco/features/auth/presentation/providers/auth_provider.dart';
import 'package:surco/features/products/domain/domain.dart';
import 'package:surco/features/products/infrastructure/infrastructure.dart';

final partysRepositoryProvider = Provider<PartysRepository>((ref) {

  final accessToken =ref.watch(authProvider).user?.token ?? '';

  final partysRepository = PartysRepositoryImpl(
    PartysDatSourceImpl(accessToken: accessToken )
  );
  return partysRepository ;
});