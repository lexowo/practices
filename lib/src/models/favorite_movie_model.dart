class FavoriteMovieModel{
  int? id;
  String? overview;
  String? poster_path;
  String? title;
  int? favorita;

  FavoriteMovieModel({this.id,this.overview,this.poster_path,this.title,this.favorita});
  
  factory FavoriteMovieModel.fromMap(Map<String,dynamic> map){
    return FavoriteMovieModel(
      id          : map['id'],
      overview    : map['overview'],
      poster_path  : map['poster_path'] ?? "",
      title       : map['title'],
      favorita    : map['favorita']
    );
  }

  Map<String,dynamic> toMap(){
    return{
      'id'          : id,
      'overview'    : overview,
      'poster_path' : poster_path,
      'title'       : title,
      'favorita'    : favorita
    };
  }
}