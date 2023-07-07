/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:surco/features/shared/shared.dart';

class LoginScreen2 extends StatelessWidget {
  const LoginScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
       child: const Column(
        children: [
          Text('Login'),
        ],
      ),
    );
  }
}
