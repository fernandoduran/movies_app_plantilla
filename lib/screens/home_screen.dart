import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/widgets/movies_search.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Instancia del provider
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartellera'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () => showSearch(context: context, delegate: MoviesSearch()), 
            icon: const Icon(Icons.search_outlined)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Targetes principals
            CardSwiper(films: moviesProvider.nowPlayingMovies),

            // Slider de pel·licules
            MovieSlider(
              movies: moviesProvider.popularMovies,
              loadNextPage: () => moviesProvider.getPopularFilms()
            ),
          ],
        ),
      ),
    );
  }
}
