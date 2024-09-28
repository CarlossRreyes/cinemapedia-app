import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){
  
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying;
  //whatcha para estar atentos a los cambios
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){
  
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getPopular;
  //whatcha para estar atentos a los cambios
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

final upComingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){
  
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getUpcoming;
  //whatcha para estar atentos a los cambios
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){
  
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getTopRated;
  //whatcha para estar atentos a los cambios
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

//CON RIVERPOD PUEDES HACER 3 O 4 INSTANCIAS DE LA MISMA CLASE
typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>>{
  //MoviesNotifier(super.state);
  int currentPage = 0;
  bool isLoading = false;

  MovieCallback fetchMoreMovies;
  
  MoviesNotifier(
    {
      required this.fetchMoreMovies
    }
  ): super([]);


  Future<void> loadNextPage() async {
    if( isLoading ) return;

    isLoading = true;
    
    // print("Obteniendo more movies");
    currentPage++;

    final List<Movie> movies = await fetchMoreMovies( page: currentPage);
    // state.addAll(movies);
    state = [...state, ...movies]; //regresar el estado actual y todas las peliculas 
    await Future.delayed( const Duration( milliseconds: 300 ));
    isLoading = false;
  }



}

