import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb/constants.dart';
import 'package:tmdb/presentation/bloc/home/featured_movies_cubit.dart';
import 'package:tmdb/presentation/bloc/home/home_state.dart';
import 'package:tmdb/presentation/bloc/home/upcoming_movies_cubit.dart';
import 'package:tmdb/presentation/keys/widget_keys.dart';
import 'package:tmdb/presentation/router/navigation_paths.dart';
import 'package:tmdb/presentation/screens/home/home_screen.dart';
import 'package:tmdb/presentation/widgets/circular_loading_indicator.dart';
import 'package:tmdb/presentation/widgets/generic_error.dart';
import 'package:tmdb/presentation/widgets/home_app_bar.dart';
import 'package:tmdb/presentation/widgets/movie_banner.dart';
import 'package:tmdb/presentation/widgets/movie_card.dart';
import 'package:tmdb/presentation/widgets/movie_category_label.dart';
import 'package:tmdb/presentation/widgets/view_more.dart';
import 'package:tmdb_custo/home_screen_filter.dart';

class HomeScreenCusto extends HomeScreen {
  const HomeScreenCusto({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FeaturedMoviesCubit _featuredMoviesCubit;
  late final UpcomingMoviesCubit _upcomingMoviesCubit;
  double maxHeaderHeight = 140;
  late ScrollController _scrollController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _featuredMoviesCubit = BlocProvider.of<FeaturedMoviesCubit>(context);
    _featuredMoviesCubit.fetchTrendingMovies();

    _upcomingMoviesCubit = BlocProvider.of<UpcomingMoviesCubit>(context);
    _upcomingMoviesCubit.fetchUpcomingMovies();

    _scrollController = ScrollController();

    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: NestedScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        scrollBehavior: const MaterialScrollBehavior(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            HomeAppBar(
                maxHeaderHeight: maxHeaderHeight,
                innerBoxIsScrolled: innerBoxIsScrolled)
          ];
        },
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            Future.wait([
              _featuredMoviesCubit.refresh(),
              _upcomingMoviesCubit.refresh()
            ]);
          },
          color: MyColors.crayolaGold,
          backgroundColor: MyColors.charcoal,
          child: ListView(
            key: WidgetKeys.homeScreenListView,
            children: [
              const SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: HomeScreenFilter()),
              const SizedBox(
                height: 40,
              ),
              MovieCategoryLabel(label: strings.featuredMovies),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<FeaturedMoviesCubit, HomeState>(
                  builder: (context, state) {
                if (state is Loading) {
                  return const CircularLoadingIndicator();
                } else if (state is LoadingFailed) {
                  return GenericError(errorDescription: state.error);
                } else if (state is Loaded) {
                  return SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: ListView.separated(
                      key: WidgetKeys.homeScreenFeaturedMoviesList,
                      itemCount: state.movies.length + 1,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final isFirst = index == 0;
                        final isLastItem = index == state.movies.length;
                        final movie = isLastItem ? null : state.movies[index];
                        return isLastItem
                            ? const Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: ViewMore(),
                              )
                            : Padding(
                                padding:
                                    EdgeInsets.only(left: isFirst ? 30 : 0),
                                child: MovieCard(
                                  key: Key(movie!.id.toString()),
                                  title: movie.title,
                                  imageUrl: movie.posterPath,
                                  onTap: () {
                                    context.push(NavigationPaths.details,
                                        extra: movie.id.toString());
                                  },
                                ),
                              );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 15,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              }),
              const SizedBox(
                height: 30,
              ),
              MovieCategoryLabel(label: strings.comingSoon),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<UpcomingMoviesCubit, HomeState>(
                  builder: (context, state) {
                if (state is Loading) {
                  return const CircularLoadingIndicator();
                } else if (state is LoadingFailed) {
                  return GenericError(errorDescription: state.error);
                } else if (state is Loaded) {
                  return SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: ListView.separated(
                      key: WidgetKeys.homeScreenUpcomingMoviesList,
                      itemCount: state.movies.length,
                      //physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        final isFirst = index == 0;
                        final isLast = index == state.movies.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(
                              left: isFirst ? 30 : 0, right: isLast ? 30 : 0),
                          child: MovieBanner(
                            title: movie.title,
                            imageUrl: movie.backdropPath,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 15,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              }),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
