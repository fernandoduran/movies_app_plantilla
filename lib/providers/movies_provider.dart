import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movies_app/constants/globals.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/models/popular_movies.dart';

class MoviesProvider extends ChangeNotifier
{
  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];


  Map<int, List<Cast>> actors = {};

  final String _tokenApi = Globals.tokenApi;
  final String _language = Globals.language;
  final String _baseUrl = Globals.apiUrl;
  
  int _nowPlayinPage = 0;
  int _popularsPage = 0;

  final StreamController<List<Movie>> _suggestionStreamContoller = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamContoller.stream;


  MoviesProvider(){

    getNowPlaying();
    getPopularFilms();
  }

  Future<String> _apiRequestResponse(String uri, [int page = 1]) async 
  {
    final url = Uri.https(_baseUrl, uri, 
      {'api_key': _tokenApi, 'language': _language, 'page': '$page'});
    
    final resp = await http.get(url);
    return resp.body;
  }

  getNowPlaying() async
  {
    try {
      _nowPlayinPage++;
      
      final resp = await _apiRequestResponse('3/movie/now_playing', _nowPlayinPage);
      final nowPlayingResponse = NowPlayingResponse.fromJson(resp);
      
      nowPlayingMovies = [...nowPlayingMovies, ...nowPlayingResponse.results];
      notifyListeners();

    } on Exception catch (e) {

      print(e);
    }
  }

  getPopularFilms() async
  {
    try {
      _popularsPage++;
      
      final resp = await _apiRequestResponse('3/movie/popular', _popularsPage);
      final popularFilms = PopularResponse.fromJson(resp);
      
      popularMovies = [...popularMovies, ...popularFilms.results];
      notifyListeners();
    } on Exception catch (e) {
      
      print(e);
    }
  }

  Future<List<Cast>> getActors(int idMovie) async
  {
    final resp = await _apiRequestResponse('3/movie/$idMovie/credits');
    final creditsResponse = CreditsResponse.fromJson(resp);

    actors[idMovie] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _tokenApi,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson( response.body );

    return searchResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm ) async {

      final results = await searchMovies(searchTerm);
      _suggestionStreamContoller.add( results );

    final timer = Timer.periodic(const Duration(milliseconds: 300), ( _ ) { 
      searchTerm;
    });

    Future.delayed(const Duration( milliseconds: 301)).then(( _ ) => timer.cancel());
  }
}