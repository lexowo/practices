import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:practica2/src/models/pupular_movies_model.dart';

class ApiPopular {
  
  //var URL = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX&page=1');

  Future<List<PopularMoviesModel>?> getAllPopular() async{
    var URL = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX&page=1');
    final response = await http.get(URL);
    if (response.statusCode == 200) {
      var popular = jsonDecode(response.body)['results'] as List;
      //debugPrint(response.body);
      List<PopularMoviesModel> listPopular = popular.map((movie) => PopularMoviesModel.fromMap(movie)).toList();
      return listPopular;
    }else{
      return null;
    }
  }
}