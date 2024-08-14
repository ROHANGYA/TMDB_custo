import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb/presentation/bloc/details/movie_details_cubit.dart';
import 'package:tmdb/presentation/router/navigation_paths.dart';
import 'package:tmdb/presentation/screens/details/details_screen.dart';
import 'package:tmdb/presentation/screens/home/home_screen.dart';
import 'package:tmdb/presentation/screens/root_scaffold.dart';
import 'package:tmdb/presentation/screens/search/search_screen.dart';
import 'package:tmdb/presentation/screens/settings/settings_screen.dart';
import 'package:tmdb_custo/home_screen_custo.dart';

final goRouterConfigCusto = GoRouter(
  initialLocation: NavigationPaths.home,
  routes: [
    ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return RootScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: NavigationPaths.home,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const HomeScreenCusto(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: NavigationPaths.search,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const SearchScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: NavigationPaths.settings,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const SettingsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
        ]),
    GoRoute(
      path: NavigationPaths.error,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: NavigationPaths.details,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider<MovieDetailsCubit>(
            create: (BuildContext context) => MovieDetailsCubit(),
            child: DetailsScreen(
              extraData: state.extra,
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/test',
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);
