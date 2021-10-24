import 'dart:io';

import 'package:flutter/material.dart';
import 'package:practica2/src/database/database_profile.dart';
import 'package:practica2/src/models/profile_model.dart';
import 'package:practica2/src/utils/color_settings.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late DatabaseProfile _databaseProfile;

  String? nombre;
  String? apellidop;
  String? apellidom;
  String? email;
  File? foto;

  @override
  // ignore: must_call_super
  void initState() {
    _databaseProfile = DatabaseProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseProfile.getPerfil(1),
        builder: (BuildContext context, AsyncSnapshot<PerfilModel> snapshot){
          if(snapshot.hasError){
            //print("Error");
            return Center(child: Text('Ocurrio un error en la peticion'),);
          }else{
            if(snapshot.connectionState == ConnectionState.done){
              //print("Success");
              nombre = snapshot.data!.nombre!;
              apellidop = snapshot.data!.apellidop!;
              apellidom = snapshot.data!.apellidom!;
              email = snapshot.data!.email!;
              foto = File(snapshot.data!.foto!);
              //print(snapshot.data!.email!);
              return _perfil();

            }else{
              //print("nope");
              return Center(child: CircularProgressIndicator(),);
            }
          }
        },
      );
  }

  Widget _perfil(){
    return Scaffold(
      appBar: AppBar(
        title: Text('DASHBOARD'),
        backgroundColor: ColorSettings.colorPrimary,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: nombre=='' ? Text('Toca el icono del lapiz para crear perfil.') : Text('$nombre $apellidop $apellidom'), 
              accountEmail: Text('$email'),
              currentAccountPicture: foto!.path == '' ? FlutterLogo() : CircleAvatar(
                backgroundImage: FileImage(foto!),
                //backgroundImage: NetworkImage('https://s.pacn.ws/1500/h1/nendoroid-no-327-animal-crossing-new-leaf-shizue-isabelle-306775.6.jpg'),
                //child: Icon(Icons.verified_user),
              ),
              decoration: BoxDecoration(
                color: ColorSettings.colorPrimary
              ),
              otherAccountsPictures: [
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/perfil').then((_){setState((){});});
                  },
                  icon: Icon(Icons.mode_edit_outline_rounded),
                  color: Colors.white,
                )
              ],
            ),
            ListTile(
              title: Text('Propinas'),
              subtitle: Text('Calculadora de Propinas'),
              leading: Icon(Icons.monetization_on_outlined),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/opc1');
              },
            ),
            ListTile(
              title: Text('Intenciones'),
              subtitle: Text('Intenciones implicitas'),
              leading: Icon(Icons.phone_android),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/intenciones');
              },
            ),
            ListTile(
              title: Text('Notas'),
              subtitle: Text('CRUD Notas'),
              leading: Icon(Icons.note),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/notas');
              },
            ),
            ListTile(
              title: Text('Movies'),
              subtitle: Text('Prueba API REST'),
              leading: Hero(tag: 'Peli', child: Icon(Icons.movie)),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/movie');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DASHBOARD'),
        backgroundColor: ColorSettings.colorPrimary,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Lex Avila'), 
              accountEmail: Text('lexavila@algo.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://s.pacn.ws/1500/h1/nendoroid-no-327-animal-crossing-new-leaf-shizue-isabelle-306775.6.jpg'),
                //child: Icon(Icons.verified_user),
              ),
              decoration: BoxDecoration(
                color: ColorSettings.colorPrimary
              ),
              otherAccountsPictures: [
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/perfil');
                  },
                  icon: Icon(Icons.edit)
                )
              ],
            ),
            ListTile(
              title: Text('Propinas'),
              subtitle: Text('Calculadora de Propinas'),
              leading: Icon(Icons.monetization_on_outlined),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/opc1');
              },
            ),
            ListTile(
              title: Text('Intenciones'),
              subtitle: Text('Intenciones implicitas'),
              leading: Icon(Icons.phone_android),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/intenciones');
              },
            ),
            ListTile(
              title: Text('Notas'),
              subtitle: Text('CRUD Notas'),
              leading: Icon(Icons.note),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/notas');
              },
            ),
          ],
        ),
      ),
    );
  }
}*/