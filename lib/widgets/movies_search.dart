

import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/providers/movies_provider.dart';

class MoviesSearch extends SearchDelegate {

  @override
  String get searchFieldLabel => 'Buscar película';

  //Botones del "AppBar" a los que se puede asignar acción
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        //Al pulsarlo, vacíamos el texto a buscar
        onPressed: () => query = '',
      )
    ];
  }
  
  //Botón de regreso del "AppBar" de la pantalla búsqueda
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => close(context, null )
    );
  }
  
  //Texto a mostrar si no se encuentran resultados
  @override
  Widget buildResults(BuildContext context) {
    
    return const Center(child: Text('No se han encontrado resultados'));
  }

  //Pantalla que se mostrará cuando no se haya hecho búsqueda
  Widget noResultsScreen() {
    return const Center(child: Icon(Icons.movie_creation_outlined, color: Color.fromARGB(255, 23, 134, 112), size: 130));
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
  
    //Si no hay texto a buscar escrito, mostramos la pantalla por defecto
    if( query.isEmpty ) return noResultsScreen();
    
    //Instancia del provider para ir haciendo consultas
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    //Pasamos al provider el texto a buscar
    moviesProvider.getSuggestionsByQuery(query);

    /**
     * Con un StreamBuilder, vamos construyendo los resultados a medida
     * que vamos escribiendo el texto a buscar. De este modeo, tenemos
     * una respuesta casi inmediata y no tenemos que hacer uso del setState()
     * para cambiar lo que se muestra por pantalla
     */
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Movie>> snapshot) {
        
        if( !snapshot.hasData ) return noResultsScreen();

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: ( _, int index ) => resultCards(_, movies[index])
        );
      },
    );
  }

  //Función que pinta los Card() de los resultados
  resultCards(context, Movie film) {
    
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'details', arguments: film),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.1),
        child: Card(
          color: const Color.fromARGB(255, 23, 134, 112),
          shape: RoundedRectangleBorder(
              borderRadius:  BorderRadius.circular(30)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(film.fullPosterImg),
                  width: 50,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text( film.title, maxLines: 2,overflow: TextOverflow.ellipsis,),
              )),
              const Icon(Icons.star, size: 15, color: Colors.yellow),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 2.0),
                child: Text('${film.voteAverage}', style: textTheme.caption),
              ),
            ],
          ),
        ),
      ),
    );
  }
}