import 'package:flutter/material.dart';
import 'package:practica2/src/screens/agregar_nota_screen.dart';
import 'package:practica2/src/screens/intenciones_screen.dart';
import 'package:practica2/src/screens/movies_screens/detail_screen.dart';
import 'package:practica2/src/screens/movies_screens/favorites_scren.dart';
import 'package:practica2/src/screens/movies_screens/popular_screen.dart';
import 'package:practica2/src/screens/notas_screen.dart';
import 'package:practica2/src/screens/opcion1_screen.dart';
import 'package:practica2/src/screens/profile_screen.dart';
import 'package:practica2/src/screens/slash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/opc1'         : (BuildContext context) => Propinas(),
        '/intenciones'  : (BuildContext context) => IntencionesScreen(),
        '/notas'        : (BuildContext context) => NotasScreen(),
        '/agregar'      : (BuildContext context) => AgregarNotaScreen(),
        '/perfil'       : (BuildContext context) => Perfil(),
        '/movie'        : (BuildContext context) => PopularScreen(),
        '/detail'       : (BuildContext context) => DetailScreen(),
        '/favoritemv'   : (BuildContext context) => FavoriteScreen()
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}