import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:practica2/src/models/pupular_movies_model.dart';

class ApiFavorite {
  
  //var URL = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX&page=1');

  Future<PopularMoviesModel?> getAllFavorite(String mv) async{
    var URL = Uri.parse('https://api.themoviedb.org/3/movie/$mv?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX');
    final response = await http.get(URL);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      var popular = jsonDecode(response.body);
      PopularMoviesModel listPopular = popular.map((movie) => PopularMoviesModel.fromMap(movie));
      return listPopular;
    }else{
      return null;
    }
  }
}