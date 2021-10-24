import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica2/src/models/actores_movies_model.dart';

class ApiActor{
  
  //var URL = Uri.parse('https://api.themoviedb.org/3/movie/550988/credits?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX');

  Future<List<ActoresModel>?> getAllActors(String mv) async{
    //var URL = Uri.parse('https://api.themoviedb.org/3/movie/550988/credits?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX');
    var URL = Uri.parse('https://api.themoviedb.org/3/movie/$mv/credits?api_key=990a15c48635b7539780bd51cbd3a351&language=es-MX');
    final response = await http.get(URL);
    if (response.statusCode == 200) {
      var actor = jsonDecode(response.body)['cast'] as List;
      List<ActoresModel> listActor = actor.map((movie) => ActoresModel.fromMap(movie)).toList();
      return listActor;
    }else{
      return null;
    }
  }
}