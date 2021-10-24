class MovieTrailerModel {

  String? key;

  MovieTrailerModel({
    this.key,
  });

  factory MovieTrailerModel.fromMap(Map<String,dynamic> map){
    return MovieTrailerModel(key: map['key']);
  }
}
