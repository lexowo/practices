import 'package:flutter/material.dart';
import 'package:practica2/src/models/pupular_movies_model.dart';

class CardPopularView extends StatefulWidget {

  final PopularMoviesModel popular;

  CardPopularView({
    Key? key,
    required this.popular
    }) : super(key: key);

  @override
  _CardPopularViewState createState() => _CardPopularViewState();
}

class _CardPopularViewState extends State<CardPopularView> {

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
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
                image: NetworkImage('https://image.tmdb.org/t/p/w500/${widget.popular.backdropPath}'),
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
                    Text(widget.popular.title!,style: TextStyle(color: Colors.white,fontSize: 12.0),),
                    MaterialButton(
                      onPressed: (){
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: {
                            'id'          : widget.popular.id,
                            'title'       : widget.popular.title,
                            'overview'    : widget.popular.overview,
                            'posterpath'  : widget.popular.posterPath
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
  }
}

/*class CardPopularView extends StatelessWidget {

  final PopularMoviesModel popular;

  const CardPopularView({
    Key? key,
    required this.popular
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}*/