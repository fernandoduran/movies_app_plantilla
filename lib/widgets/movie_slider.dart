// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';

class MovieSlider extends StatefulWidget {
  
  final List<Movie> movies;
  final Function loadNextPage;
  
  const MovieSlider({
    Key? key, 
    required this.movies,
    required this.loadNextPage
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();
  
  @override
  void initState(){

    super.initState();
    /**
     * Evento Listener al controller del scroll apra cargar más datos
     * cuando llegue al final del scroll
     */
    scrollController.addListener(() {
      //Capturamos posción actual y el máximo de pixels del scroll
      var pixelsPosition = scrollController.position.pixels;
      var maxScroll = scrollController.position.maxScrollExtent;

      //Cauando la posición actual se acerque al final, cargamos más datos
      if (pixelsPosition >= maxScroll - 150) widget.loadNextPage();
    });
  }

  @override
  void dispose() => super.dispose();
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Populars',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold)
              ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int i) => _MoviePoster(movie: widget.movies[i])),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  //Instancia del modelo Movie
  final Movie movie; 
  
  const _MoviePoster({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: movie),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                width: 130,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          //Englobamos en un Expanded para evitar overflow de pixels
          Expanded(
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
