import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practica2/src/models/favorite_movie_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseFavoriteMovie{
  static final _nombreBD = "FAVMVBD";
  static final _versionBD = 1;
  static final _nombreTBL = "tblPeliculas";

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
    await db.execute("CREATE TABLE $_nombreTBL (id INTEGER PRIMARY KEY, overview VARCHAR(200), poster_path VARCHAR(100), title VARCHAR(100), favorita Boolean)");
  }

  Future<int> insert(Map<String,dynamic> row) async{
    var conexion = await database;
    return conexion!.insert(_nombreTBL, row);
  }

  Future<int> update(Map<String,dynamic> row) async{
    var conexion = await database;
     return conexion!.update(_nombreTBL, row, where: 'id= ?', whereArgs: [row['id']]);
  }

  Future<int> delete(int id) async{
    var conextion = await database;
    return await conextion!.delete(_nombreTBL,where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FavoriteMovieModel>> getAll() async{
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL);
    return result.map((notaMap) => FavoriteMovieModel.fromMap(notaMap)).toList();
  }

  Future<FavoriteMovieModel> getOne(int id) async{
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL,where: 'id=?',whereArgs: [id]);
    //result.map((notaMap) => NotasModel.fromMap(notaMap)).first;
    return FavoriteMovieModel.fromMap(result.first);
  }

  crear(int id, String overview, String poster_path, String title) async{
    var conexion = await database;
    await conexion!.execute("INSERT OR IGNORE INTO $_nombreTBL (id,overview,poster_path,title,favorita) VALUES (?,?,?,?,?)",[id,overview,poster_path,title,0]);
    List<Map> res = await conexion.rawQuery('SELECT * FROM $_nombreTBL');
  }
}