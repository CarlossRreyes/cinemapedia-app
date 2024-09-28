import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class FavoriteView extends ConsumerStatefulWidget {
  const FavoriteView({super.key});

  @override
  FavoriteViewState createState() => FavoriteViewState();
}

class FavoriteViewState extends ConsumerState<FavoriteView> {

  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // ref.read( favoriteMoviesProvider.notifier ).loadNextPage();
    loadNextPage();
  }

  void loadNextPage() async {
    if ( isLoading || isLastPage ) return; //SI ESTOY CARGANDO O SI ESTOY EN LA ULTIMA PAGINA NO HAY QUE VOLVER A CARGAR
    isLoading = true;
    final movies = await ref.read( favoriteMoviesProvider.notifier ).loadNextPage();
    isLoading = false;

    if( movies.isEmpty ){
      isLastPage = true;
    } 

  }

  @override
  Widget build(BuildContext context) {

    final favoriteMovies = ref.watch( favoriteMoviesProvider ).values.toList();
    //convertir de mapa a lista

    if (favoriteMovies.isEmpty ){
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon( Icons.favorite_border_sharp, size: 60, color: colors.primary,),
            Text("Ohhh no!!", style: TextStyle( fontSize: 30, color: colors.primary),),
            const Text("Aún no tienes peliculas favoritas", style: TextStyle( fontSize: 20, color: Colors.black45),),
            FilledButton(
              onPressed: () => context.go("/home/0"), 
              child: const Text("Empieza a buscar")
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(movies: favoriteMovies)
    );
  }
}