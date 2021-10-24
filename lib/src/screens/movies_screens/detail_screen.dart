import 'package:flutter/material.dart';
import 'package:practica2/src/database/database_favorite_movie.dart';
import 'package:practica2/src/models/actores_movies_model.dart';
import 'package:practica2/src/models/favorite_movie_model.dart';
import 'package:practica2/src/models/trailer_movies_model.dart';
import 'package:practica2/src/network/api_actores.dart';
import 'package:practica2/src/network/api_trailer.dart';
import 'package:practica2/src/utils/color_settings.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  ApiTrailer? apiTrailer;
  ApiActor? apiActor;
  late DatabaseFavoriteMovie _databaseFavoriteMovie;

  @override
  void initState() {
    super.initState();
    _databaseFavoriteMovie = DatabaseFavoriteMovie();
    apiTrailer = ApiTrailer();
    apiActor = ApiActor();
  }

  @override
  Widget build(BuildContext context) {

    final movie = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;

    _databaseFavoriteMovie.crear(movie['id'],movie['overview'],movie['posterpath'],movie['title']);

    return Scaffold(
      body: FutureBuilder(
        future: apiTrailer!.getAllTrailer(movie['id'].toString()),
        builder: (BuildContext context, AsyncSnapshot<List<MovieTrailerModel>?> snapshot){
          if (snapshot.hasError) {
            return Center(child: Text('Hay error en la peticion'),);
          }else{
            if (snapshot.connectionState == ConnectionState.done) {
              return _detalleMovie(snapshot.data);
            }else{
              return CircularProgressIndicator();
            }
          }
        }
      ),
    );

  }

  List<Widget> lista(){
    return [
      Icon(Icons.access_alarm, size: 80,),
      Icon(Icons.account_balance, size: 80,),
      Icon(Icons.add_comment, size: 80,),
      Icon(Icons.access_alarm, size: 80,),
      Icon(Icons.account_balance, size: 80,),
      Icon(Icons.add_comment, size: 80,),
      Icon(Icons.access_alarm, size: 80,),
      Icon(Icons.account_balance, size: 80,),
      Icon(Icons.add_comment, size: 80,),
      Icon(Icons.access_alarm, size: 80,),
      Icon(Icons.account_balance, size: 80,),
      Icon(Icons.add_comment, size: 80,),
      Icon(Icons.access_alarm, size: 80,),
      Icon(Icons.account_balance, size: 80,),
      Icon(Icons.add_comment, size: 80,),
    ];
  }

  Widget _detalleMovie(List<MovieTrailerModel>? trailer){

    final movie = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;

    MovieTrailerModel trailers;

    if (trailer != null && trailer.length > 0) {
      print('xd');
      trailers = trailer[0];

        YoutubePlayerController _controller = YoutubePlayerController(
          initialVideoId: trailers.key!,
          flags: YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
          ),
        );

      return Scaffold(
        appBar: AppBar(
          title: Text(movie['title']),
          backgroundColor: ColorSettings.colorPrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
              children: [
                Row(
                  children: [
                    Image(image: NetworkImage('https://image.tmdb.org/t/p/w500/${movie['posterpath']}'),height: 130,),
                    SizedBox(width: 120,),
                    FutureBuilder(
                      future: _databaseFavoriteMovie.getOne(movie['id']),
                      builder: (BuildContext context, AsyncSnapshot<FavoriteMovieModel> snapshot){
                        if(snapshot.hasError){
                          return Center(child: Text('Ocurrio un error en la peticion'),);
                        }else{
                          if(snapshot.connectionState == ConnectionState.done){
                            return _favorita(snapshot.data!);
                          }else{
                            return Center(child: CircularProgressIndicator(),);
                          }
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text('Trailer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressColors: ProgressBarColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.amberAccent,
                  ),
                  onReady:  () {
                  },
                ),
                SizedBox(height: 10,),
                Text(movie['overview'], style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text('Actores y Actrices', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                FutureBuilder(
                  future: apiActor!.getAllActors(movie['id'].toString()),
                  builder: (BuildContext context, AsyncSnapshot<List<ActoresModel>?> snapshot){
                    if (snapshot.hasError) {
                      return Center(child: Text('Hay error en la peticion'),);
                    }else{
                      if (snapshot.connectionState == ConnectionState.done) {
                        return _detalleActores(snapshot.data);
                      }else{
                        return CircularProgressIndicator();
                      }
                    }
                  }
                ),
              ],
            ),
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: Text(movie['title']),
          backgroundColor: ColorSettings.colorPrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
              children: [
                Row(
                  children: [
                    Image(image: NetworkImage('https://image.tmdb.org/t/p/w500/${movie['posterpath']}'),height: 130,),
                    SizedBox(width: 120,),
                    FutureBuilder(
                      future: _databaseFavoriteMovie.getOne(movie['id']),
                      builder: (BuildContext context, AsyncSnapshot<FavoriteMovieModel> snapshot){
                        if(snapshot.hasError){
                          return Center(child: Text('Ocurrio un error en la peticion'),);
                        }else{
                          if(snapshot.connectionState == ConnectionState.done){
                            return _favorita(snapshot.data!);
                          }else{
                            return Center(child: CircularProgressIndicator(),);
                          }
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text('Sin Trailer Disponible', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(movie['overview'], style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text('Actores y Actrices', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                FutureBuilder(
                  future: apiActor!.getAllActors(movie['id'].toString()),
                  builder: (BuildContext context, AsyncSnapshot<List<ActoresModel>?> snapshot){
                    if (snapshot.hasError) {
                      return Center(child: Text('Hay error en la peticion'),);
                    }else{
                      if (snapshot.connectionState == ConnectionState.done) {
                        return _detalleActores(snapshot.data);
                      }else{
                        return CircularProgressIndicator();
                      }
                    }
                  }
                ),
              ],
            ),
        ),
      );
    }
  }

  Widget _detalleActores(List<ActoresModel>? actores){
    return Container(
      height: 110,
      child: ListView.builder(
        itemCount: actores!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          ActoresModel actor = actores[index];
          //return Text(actor.name!);
          //debugPrint('aaaaaa');
          //debugPrint(actor.profile_path);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //FlutterLogo(size: 70,),
                  CircleAvatar(
                    backgroundImage: actor.profile_path != null ? NetworkImage('https://image.tmdb.org/t/p/w500/${actor.profile_path}') : Image.asset('assets/default.png').image,
                    radius: 35,
                  ),
                  Text(actor.name!)
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _favorita(FavoriteMovieModel movies){
    //return Text(movies.favorita.toString());
    bool favorite;
    movies.favorita==1 ? favorite=true: favorite=false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Favorita', style: TextStyle(fontSize: 18),),
        Checkbox(
          value: favorite,
          activeColor: Colors.amber[700],
          onChanged: (bool? value){
            print('xd');
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: favorite ? Text('¿Quitar de favoritos?') : Text('¿Marcar como favorita?'),
                  //content: favorite ? Text('¿Quieres quitar tu tarea entregada?') : Text('¿Estas seguro que quieres marcar tu tarea como entregada?'),
                  actions: [
                    TextButton(
                      onPressed: (){
                        FavoriteMovieModel moviefav = FavoriteMovieModel(
                          id: movies.id,
                          overview: movies.overview,
                          poster_path: movies.poster_path,
                          title: movies.title,
                          favorita: value! ? 1 : 0
                        );
                        _databaseFavoriteMovie.update(moviefav.toMap()).then((valor){
                          if (valor > 0) {
                            Navigator.pop(context);
                            setState(() {
                              favorite = value;
                            });
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('La solicitud no se completo'))
                            );
                          }
                        });
                      }, 
                      child: Text('Si')
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar')
                    )
                  ],
                );
              }
            );
          } ,
        ),
      ],
    );
  }
}