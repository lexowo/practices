import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:practica2/src/database/database_profile.dart';
import 'package:practica2/src/models/profile_model.dart';
import 'package:practica2/src/utils/color_settings.dart';

class Perfil extends StatefulWidget {
  Perfil({Key? key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  late DatabaseProfile _databaseProfile;

  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerApellidoP = TextEditingController();
  TextEditingController _controllerApellidoM = TextEditingController();
  TextEditingController _controllerNumtel = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  String? fotosrc;
  bool newImg=false;
  String? newImgsrc;

  File? imagen;

  Future agregarImagen(ImageSource src) async{
    try {
      final imagen = await ImagePicker().pickImage(source: src);
      if (imagen==null) return;
      
      //final imagenTemp = File(imagen.path);
      final imagenPerm = await guardarImagen(imagen.path);
      setState(() {
        this.imagen = imagenPerm;
      });
    } on PlatformException catch (e) {
      print('Fallo al seleccionar imagen $e');
    }
  }

  Future<File> guardarImagen(String imagenPath) async{
    final directorio = await getApplicationDocumentsDirectory();
    final nombre = Path.basename(imagenPath);
    final imagen = File('${directorio.path}/$nombre');

    newImg=true;
    newImgsrc=imagen.path;
    //print('IMagen sacada: ${imagen.path}');

    return File(imagenPath).copy(imagen.path);
  }

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
              newImg ? _controllerNombre.text=_controllerNombre.text : _controllerNombre.text = snapshot.data!.nombre!;
              newImg ? _controllerApellidoP.text=_controllerApellidoP.text :_controllerApellidoP.text = snapshot.data!.apellidop!;
              newImg ? _controllerApellidoM.text=_controllerApellidoM.text :_controllerApellidoM.text = snapshot.data!.apellidom!;
              newImg ? _controllerNumtel.text=_controllerNumtel.text :_controllerNumtel.text = snapshot.data!.numtel!;
              newImg ? _controllerEmail.text=_controllerEmail.text :_controllerEmail.text = snapshot.data!.email!;
              fotosrc = snapshot.data!.foto!;
              newImg ? imagen = File(newImgsrc!) : imagen = File(snapshot.data!.foto!);
              //return Text(snapshot.data!.nombre!);
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
    //imagen == File(fotosrc!) ? imagen = File(fotosrc!) : null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSettings.colorPrimary,
        title: Text('Editar Perfil'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10,),
          Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              imagen!.path != '' ? ClipOval(child: Image.file(imagen!, width: 160, height: 160, fit: BoxFit.cover,)) : FlutterLogo(size: 160,),
              SizedBox(width: 20,),
              //ClipOval(child: Image.file(File('/data/user/0/com.example.practica2/app_flutter/094d26fe-389a-47d1-a469-c25afe07d8873121643750691709588.jpg'), width: 160, height: 160, fit: BoxFit.cover,)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  ElevatedButton(onPressed: ()=>agregarImagen(ImageSource.camera), child: Icon(Icons.camera),),
                  ElevatedButton(onPressed: ()=>agregarImagen(ImageSource.gallery), child: Icon(Icons.photo)),
                ],
              ),
            ]
          ),
          SizedBox(height: 10,),
          _crearTextFieldNombre(),
          SizedBox(height: 10,),
          _crearTextFieldApellidoP(),
          SizedBox(height: 10,),
          _crearTextFieldApellidoM(),
          SizedBox(height: 10,),
          _crearTextFieldNumtel(),
          SizedBox(height: 10,),
          _crearTextFieldEmail(),
          ElevatedButton(
            onPressed: (){
              PerfilModel perfil = PerfilModel(
                id  : 1,
                nombre: _controllerNombre.text,
                apellidop: _controllerApellidoP.text,
                apellidom: _controllerApellidoM.text,
                numtel: _controllerNumtel.text,
                email: _controllerEmail.text,
                foto: newImg ? newImgsrc : imagen!.path,
              );
              if(_controllerNombre.text=='' || _controllerApellidoP.text=='' || _controllerApellidoM.text=='' || _controllerNumtel.text=='' || _controllerEmail.text=='' || double.tryParse(_controllerNumtel.text)==null){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Error'),
                    content: Text(
                      'Porfavor llene todos los campos para completar su perfil.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Ok',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      )
                    ],
                  )
                );
              }else{
                //print('Imagen a guardar ${imagen!.path}');
                _databaseProfile.update(perfil.toMap()).then(
                  (value){
                    if(value>0){
                      Navigator.pop(context);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('La solicitud no se completo'))
                      );
                    }
                  }
                );
              }
            },
            child: Text('Guardar Perfil'),
          )
        ],
      ),
    );
  }

  Widget _crearTextFieldNombre(){
    return TextField(
      controller: _controllerNombre,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Nombre",
        //errorText: "Este campo es obligatorio"
      ),
      onChanged: (value){

      },
    );
  }

  Widget _crearTextFieldApellidoP(){
    return TextField(
      controller: _controllerApellidoP,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Apellido Paterno",
        //errorText: "Este campo es obligatorio",
      ),
      onChanged: (value){

      },
    );
  }

    Widget _crearTextFieldApellidoM(){
    return TextField(
      controller: _controllerApellidoM,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Apellido Materno",
        //errorText: "Este campo es obligatorio"
      ),
      onChanged: (value){

      },
    );
  }

    Widget _crearTextFieldNumtel(){
    return TextField(
      controller: _controllerNumtel,
      keyboardType: TextInputType.number,
      maxLength: 10,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Numero telefonico",
        //errorText: "Este campo es obligatorio"
      ),
      onChanged: (value){

      },
    );
  }

    Widget _crearTextFieldEmail(){
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Correo electronico",
        //errorText: "Este campo es obligatorio"
      ),
      onChanged: (value){

      },
    );
  }

}