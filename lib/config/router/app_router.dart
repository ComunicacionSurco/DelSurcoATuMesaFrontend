/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:surco/features/auth/auth.dart';
import 'package:surco/config/router/app_router_notifier.dart';
import 'package:surco/features/auth/presentation/providers/auth_provider.dart';
import 'package:surco/features/products/products.dart';
import 'package:surco/video/presentation/screens/discover/discover_screen.dart';


import '../../features/products/presentation/screens/product_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);


  return GoRouter(
    initialLocation: '/splash',
    refreshListenable:goRouterNotifier ,
    routes: [
      ///* Auth Routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),

    
     GoRoute(
        path: '/videos',
        builder: (context, state) => const DiscoverScreen(),
    ), 

      GoRoute(
        path: '/partys/:id',
        builder: (context, state) => ProductScreen(
          productId: state.params['id'] ?? 'no-id',
        ),  
      ),
    ],

    redirect: (context,state){
      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if(isGoingTo =='/splash' && authStatus == AuthStatus.checking) return null;

      if(authStatus == AuthStatus.notAuthenticated){
        if(isGoingTo == '/login' || isGoingTo == '/register') return null;
      
      return '/login';
      }

      if(authStatus == AuthStatus.authenticated){
        if(isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splash') return '/';
      }

      return null;
    },
  );
});
