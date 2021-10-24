import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica2/src/models/trailer_movies_model.dart';

class ApiTrailer{
  
  //var URL = Uri.parse('https://api.themoviedb.org/3/movie/580489/videos?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX');

  Future<List<MovieTrailerModel>?> getAllTrailer(String mv) async{
    //var URL = Uri.parse('https://api.themoviedb.org/3/movie/580489/videos?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX');
    var URL = Uri.parse('https://api.themoviedb.org/3/movie/$mv/videos?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX');
    final response = await http.get(URL);
    if (response.statusCode == 200) {
      var trailer = jsonDecode(response.body)['results'] as List;
      List<MovieTrailerModel> listTrailer = trailer.map((movie) => MovieTrailerModel.fromMap(movie)).toList();
      return listTrailer;
    }else{
      return null;
    }
  }
}