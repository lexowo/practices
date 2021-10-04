import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:practica2/src/models/profile_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProfile{
  static final _nombreBD = "PERFILBD";
  static final _versionBD = 1;
  static final _nombreTBL = "tblPerfil";

  static Database? _database;

  Future<Database?> get database async{
    if( _database != null ) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async{
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaBD = join(carpeta.path,_nombreBD);
    return openDatabase(
      rutaBD,
      version: _versionBD,
      onCreate: _crearTabla
    );
  }

  _crearTabla(Database db, int version) async{
    await db.execute("CREATE TABLE $_nombreTBL (id INTEGER PRIMARY KEY, nombre VARCHAR(100), apellidop VARCHAR(100), apellidom VARCHAR(100), numtel VARCHAR(100), email VARCHAR(100), foto VARCHAR(200))");
    await db.execute("INSERT INTO $_nombreTBL (id, nombre, apellidop, apellidom, numtel, email, foto) VALUES (1,'','','','','','')");
    print("dbcreada");
  }

  Future<int> update(Map<String,dynamic> row) async{
    var conexion = await database;
     return conexion!.update(_nombreTBL, row, where: 'id= ?', whereArgs: [row['id']]);
  }

  Future<List<PerfilModel>> getAllProfiles() async{
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL);
    return result.map((perfilMap) => PerfilModel.fromMap(perfilMap)).toList();
  }

    Future<PerfilModel> getPerfil(int id) async{
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL,where: 'id=?',whereArgs: [id]);
    //print('getperf');
    //result.map((notaMap) => NotasModel.fromMap(notaMap)).first;
    return PerfilModel.fromMap(result.first);
  }
}