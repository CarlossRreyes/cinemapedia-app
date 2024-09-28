import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';


class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    super.key
  });

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState() {
    super.initState();
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( upComingMoviesProvider.notifier ).loadNextPage();
    ref.read( topRatedMoviesProvider.notifier ).loadNextPage();

  }
  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch( initialLoadingProvider );
    if( initialLoading ) return const FullScreenLoader();


    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final slideShowMovies = ref.watch( moviesSlideshowProvider );
    final popularMovies = ref.watch( popularMoviesProvider );
    final upComingMovies = ref.watch( upComingMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );

    

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
            titlePadding: EdgeInsets.zero,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index){
            return 
              Column(
                  children: [
                    // const CustomAppbar(),
              
                    MoviesSlideshow(movies: slideShowMovies),
              
                    MovieHorizontalListview(
                      title: "En cines",
                      subTitle: "Lunes 20",
                      movies: nowPlayingMovies,
                      loadNextPage: () => ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      title: "Proximamente",
                      // subTitle: "Lunes 20",
                      movies: upComingMovies,
                      loadNextPage: () => ref.read( upComingMoviesProvider.notifier ).loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      title: "Populares en tu cuidad",
                      // subTitle: "Lunes 20",
                      movies: popularMovies,
                      loadNextPage: () => ref.read( popularMoviesProvider.notifier ).loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      title: "Mejores calificadas",
                      subTitle: "Top",
                      movies: topRatedMovies,
                      loadNextPage: () => ref.read( topRatedMoviesProvider.notifier ).loadNextPage(),
                    ),

                    const SizedBox(
                      height: 20,
                    )
              
                    
                  ],
              );
          },
          childCount: 1
          )
          
        )
      ]
     
    );
    
  }
}