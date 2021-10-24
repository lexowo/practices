import 'package:flutter/material.dart';
import 'package:practica2/src/database/database_favorite_movie.dart';
import 'package:practica2/src/models/favorite_movie_model.dart';
import 'package:practica2/src/network/api_popular.dart';
import 'package:practica2/src/utils/color_settings.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  //ApiPopular? apiPopular;
  ApiPopular? apiPopular;
  late DatabaseFavoriteMovie _databaseFavoriteMovie;

  @override
  void initState() {
    super.initState();
    //apiPopular = ApiPopular();
    apiPopular = ApiPopular();
    _databaseFavoriteMovie = DatabaseFavoriteMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSettings.colorPrimary,
        title: Text('Favoritas'),
      ),
      body: FutureBuilder(
        future: _databaseFavoriteMovie.getAll(),
        builder: (BuildContext context, AsyncSnapshot<List<FavoriteMovieModel>> snapshot){
          if (snapshot.hasError) {
            return Center(child: Text('Hay error en la peticion'),);
          }else{
            if (snapshot.connectionState == ConnectionState.done) {
              return _favoritas(snapshot.data!);
            }else{
              return CircularProgressIndicator();
            }
          }
        }
      )
    );
  }

  Widget _favoritas(List<FavoriteMovieModel> favs){
    return ListView.separated(
      itemBuilder: (context,index){
        FavoriteMovieModel favorita = favs[index];
        //return Text(favorita.id.toString());
        if (favorita.favorita==1) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  offset: Offset(0.0, 5.0),
                  blurRadius: 2.5
                )
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children:[
                  Container(
                    child: Image(
                      image: NetworkImage('https://image.tmdb.org/t/p/w500/${favorita.poster_path}'),
                    ),
                  ),
                  Opacity(
                    opacity: .5,
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      height: 60.0,
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(favorita.title!,style: TextStyle(color: Colors.white,fontSize: 12.0),),
                          MaterialButton(
                            onPressed: (){
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: {
                                  'id'          : favorita.id,
                                  'title'       : favorita.title,
                                  'overview'    : favorita.overview,
                                  'posterpath'  : favorita.poster_path
                                }
                              ).whenComplete((){setState(() {});});
                            },
                            child: Icon(Icons.chevron_right, color: Colors.white,),
                          )
                        ],
                      ),
                    ),
                  )
                ]
              ),
            ),
          );
        }else{
          return Container();
        }
        
      },
      separatorBuilder: (_,__) => Divider(height: 10,),
      itemCount: favs.length
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSettings.colorPrimary,
        title: Text('Peliculas'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.favorite)
          )
        ],
      ),
      // body: FutureBuilder(
      //   future: apiPopular!.getAllPopular(),
      //   builder: (BuildContext context, AsyncSnapshot<List<PopularMoviesModel>?> snapshot){
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Hay error en la peticion'),);
      //     }else{
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         return _listPopularMovies(snapshot.data);
      //       }else{
      //         return CircularProgressIndicator();
      //       }
      //     }
      //   }
      // ),
      body: FutureBuilder(
        future: _databaseFavoriteMovie.getAll(),
        builder: (BuildContext context, AsyncSnapshot<List<FavoriteMovieModel>?> snapshot){
          if (snapshot.hasError) {
            return Center(child: Text('Hay error en la peticion'),);
          }else{
            if (snapshot.connectionState == ConnectionState.done) {
              return _listFavoriteMovies(snapshot.data);
            }else{
              return CircularProgressIndicator();
            }
          }
        }
      ),
    );
  }

  Widget _listFavoriteMovies(List<FavoriteMovieModel>? favs){
    return ListView.separated(
      itemBuilder: (context,index){
        FavoriteMovieModel favoritas = favs![index];
        return FutureBuilder(
          future: apiFavorite!.getAllFavorite('550988'),
          builder: (BuildContext context, AsyncSnapshot<PopularMoviesModel?> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Hay error en la peticion'),);
            }else{
              if (snapshot.connectionState == ConnectionState.done) {
                return _listPopularMovies(snapshot.data);
              }else{
                return CircularProgressIndicator();
              }
            }
          },
        );
      },
      separatorBuilder: (_,__) => Divider(height: 10,), 
      itemCount: favs!.length);
  }

  Widget _listPopularMovies(PopularMoviesModel? movies){
        PopularMoviesModel popular = movies!;
        //return CardPopularView(popular: popular);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                offset: Offset(0.0, 5.0),
                blurRadius: 2.5
              )
            ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children:[
                Container(
                  child: FadeInImage(
                    placeholder: AssetImage('assets/activity_indicator.gif'),
                    image: NetworkImage('https://image.tmdb.org/t/p/w500/${popular.backdropPath}'),
                    fadeInDuration: Duration(milliseconds: 200),
                  ),
                ),
                Opacity(
                  opacity: .5,
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    height: 60.0,
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(popular.title!,style: TextStyle(color: Colors.white,fontSize: 12.0),),
                        MaterialButton(
                          onPressed: (){
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: {
                                'id'          : popular.id,
                                'title'       : popular.title,
                                'overview'    : popular.overview,
                                'posterpath'  : popular.posterPath
                              }
                            );
                          },
                          child: Icon(Icons.chevron_right, color: Colors.white,),
                        )
                      ],
                    ),
                  ),
                )
              ]
            ),
          ),
        );
  }*/
}