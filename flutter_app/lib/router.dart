import 'package:flutter_app/screens/document_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
// import 'package:go_router/go_router.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeScreen()),
  '/document/:id': (route) => MaterialPage(
        child: DocumentScreen(
          id: route.pathParameters['id'] ?? '',
        ),
      ),
});

// final goLoggedOutRout = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const LoginScreen(),
//     )
//   ],
// );

// final goLoggedInRoute = GoRouter(routes: [
//   GoRoute(
//     path: '/',
//     builder: (context, state) => const LoginScreen(),
//   ),
//   GoRoute(
//     path: '/document/:id',
//     builder: (context, state) => DocumentScreen(
//       id: state.pathParameters['id'] ?? '',
//     ),
//   ),
// ]);

// final goRouters = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const LoginScreen(),
//       routes: [
//         GoRoute(
//       path: '/document/:id',
//       builder: (context, state) => DocumentScreen(
//         id: state.pathParameters['id'] ?? '',
//       ),
//     ),
//       ]
//     ),
    
//   ],
// );
