class PerfilModel {
  int? id;
  String? nombre;
  String? apellidop;
  String? apellidom;
  String? numtel;
  String? email;
  String? foto;

  PerfilModel({this.id,this.nombre,this.apellidop,this.apellidom,this.numtel,this.email,this.foto});

  //Map -> object
  factory PerfilModel.fromMap(Map<String,dynamic> map){//cualquier nombre
    return PerfilModel(
      id      : map['id'],
      nombre  : map['nombre'],
      apellidop : map['apellidop'],
      apellidom : map['apellidom'],
      numtel : map['numtel'],
      email : map['email'],
      foto  : map['foto']
    );
  }
  
  //Object Map
  Map<String,dynamic> toMap(){
    return{
      'id'  : id,
      'nombre'  : nombre,
      'apellidop' : apellidop,
      'apellidom' : apellidom,
      'numtel' : numtel,
      'email' : email,
      'foto'  : foto
    };
  }

}