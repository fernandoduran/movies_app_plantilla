import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/models/models.dart';

class CastingCards extends StatelessWidget {

  final int idFilm;

  const CastingCards(this.idFilm, {super.key});

  @override
  Widget build(BuildContext context) {
    
    //Instancia del provider
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    //Con FutureBuilder, cargamos los actores de la película que estamos consultando
    return FutureBuilder(
      future: moviesProvider.getActors(idFilm),
      builder: (context, snapshot) {

        //Mientras cargan los resultados, mostramos un indicador de progeso
        if(!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final List<Cast> actorsList = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          // color: Colors.red,
          child: ListView.builder(
            itemCount: actorsList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) => _CastCard(actorsList[i])
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {

  //Instancia del modelo de Actores
  final Cast actor;

  const _CastCard(this.actor);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
