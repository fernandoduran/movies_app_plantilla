import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/movie_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> films;

  const CardSwiper({Key? key, required this.films}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    if(films.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return SizedBox(
      width: double.infinity,
      // Aquest multiplicador estableix el tant per cent de pantalla ocupada 50%
      height: size.height * 0.5,
      // color: Colors.red,
      child: Swiper(
        itemCount: films.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (BuildContext context, int i) => moviesCard(context, films[i]),
      )
    );
  }

  moviesCard(BuildContext context, Movie film) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'details', arguments: film),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child:  FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(film.fullPosterImg),
          fit: BoxFit.cover
        ),
      ),
    );
  }
}
