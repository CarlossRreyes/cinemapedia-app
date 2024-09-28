

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function( String query );

class SearchMovieDelegate extends SearchDelegate<Movie?>{

  
  final SearchMoviesCallback searchMoviesCallback;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  List<Movie> initiaLMovies;


  SearchMovieDelegate({
    required this.searchMoviesCallback,
    required this.initiaLMovies
  });

  void clearStreams(){
    debouncedMovies.close();
  }

  void _onQueryChanged( String query ){

    // print("Query string cambio");
    //cuando se empieza a escribir
    isLoadingStream.add(true);

    if ( _debounceTimer?.isActive ?? false ) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration( milliseconds: 500 ), () async{
      // print("Buscando peliculas");
      // if ( query.isEmpty ){
      //   debouncedMovies.add([]);
      //   return;
      // }

      final movies = await searchMoviesCallback( query );
      initiaLMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
     });

  }

  Widget buildResultsAndSuggestion(){
    return StreamBuilder(
      // future: searchMoviesCallback(query),    
      initialData: initiaLMovies,  
      stream: debouncedMovies.stream,
      
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: ( context, movie){
              print("PRESIONANDO");
              
              clearStreams();
              close(context, movie);
            }
          ),
          
        );
      },
    );

  }

  @override
  String get searchFieldLabel => "Buscar película";

  @override
  List<Widget>? buildActions(BuildContext context) {
    
    return [

      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if ( snapshot.data ?? false ){
            return SpinPerfect(
              duration: const Duration( seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = "",
                icon: const Icon( Icons.refresh_rounded)
              ),
            );
          }

          return FadeIn(
            child: IconButton(
              onPressed: () => query = "",
              icon: const Icon( Icons.clear)
            )
          ); 
        },
      )

        

      
     
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        clearStreams();
        close(context, null);
      },
      icon: const Icon( Icons.arrow_back )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestion();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return buildResultsAndSuggestion();
  }

}


class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie, required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 5),
        child: Row(
          children: [
    
    
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network( movie.posterPath ),
              ),
            ),
    
            const SizedBox( width: 10,),
    
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                
                  Text( movie.title, style: textStyle.titleMedium, ),
                  ( movie.overview.length > 100)
                   ? Text( "${ movie.overview.substring(0, 100)}...", textAlign: TextAlign.justify, )
                   : Text( movie.overview ),
    
                  Row(
                    children: [
                      Icon( Icons.star_half_rounded, color: Colors.yellow.shade800,),
                      const SizedBox( width: 5,),
                      Text( 
                        HumanFormats.number( movie.voteAverage, 1 ),
                        style: textStyle.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}