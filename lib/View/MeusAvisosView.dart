import 'package:flutter/material.dart';
import 'package:untitled/Controller/AvisosController.dart';
import 'package:untitled/Model/AvisoListagemModel.dart';
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:untitled/View/AvisoListagemView.dart';
import 'package:untitled/View/AvisoRegistroView.dart';
import 'package:untitled/View/MapaAvisosView.dart';
import 'package:untitled/View/MeusAnimaisView.dart';
import 'package:untitled/View/UsuarioLoginView.dart';
import 'package:untitled/View/UsuarioPerfilView.dart';

//ignore: must_be_immutable
class MeusAvisos extends StatefulWidget {

  UsuarioModel user = new UsuarioModel();
  MeusAvisos(this.user);

  @override
  _MeusAvisosState createState() => _MeusAvisosState();
}

class _MeusAvisosState extends State<MeusAvisos> {

  UsuarioModel usuario = new UsuarioModel();

  @override
  void initState(){
    super.initState();
    usuario = widget.user;
  }

  int _currendIndex = 0 ;

  AvisosController ac = new AvisosController();
  int idusuario=0;
  List<AvisoListagem> avisos = [];
  late Future<String> dados;
  bool buscaRealizada=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text("Meus Avisos",
        ),
        leading: PopupMenuButton<int>(
          onSelected: (item) => onSelected(context, item),
          icon: Icon(Icons.menu),
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("${widget.user.nome}",)
                  ],
                )
            ),PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.email, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("${widget.user.email}",)
                  ],
                )
            ),PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("Meus Avisos",)
                  ],
                )
            ),PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("Meus Animais")
                  ],
                )
            ),PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.perm_contact_cal_rounded, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("Editar Perfil")
                  ],
                )
            ),PopupMenuItem(
                value: 5,
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("Sair")
                  ],
                )
            ),

          ],
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistroAviso(usuario) ));
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<AvisoListagem>>(
          future: ac.getAvisosPorUsuario(usuario).then((value) {
            buscaRealizada = true;
            return avisos = value;
          }), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot dados) {

            if(avisos.length > 0) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
                padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    // onPressed: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => DetalharAviso(avisos[index])));
                    // },
                    padding: EdgeInsets.all(3),
                    color: Colors.white10,
                    // onPrimary: Colors.black,
                    // ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: corAviso(avisos[index].estado)
                            // color: Colors.yellowAccent
                          ),
                          child: Center(
                            child: Text(estadoAviso(avisos[index].estado),
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          ),),
                          padding: EdgeInsets.only(top: 3),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 25,
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 95,
                          child: FittedBox(
                            child: Image.network("${avisos[index].fotoanimal}"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                            child: Center(
                              child: Text(
                                "${avisos[index].nome}".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.black87
                            )
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          child: Row(
                              children: [
                                Expanded(child:
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  "Remover Aviso?"),
                                              content: const Text(
                                                  "Deseja remover o aviso selecionado?"),
                                              actions: [
                                                // ElevatedButton(onPressed: () => Navigator.pop(context, 'Confirmar'),
                                                ElevatedButton(onPressed: () {
                                                  ac.editarStatusAviso(
                                                      avisos[index])
                                                      .whenComplete(() =>
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  MeusAvisos(
                                                                      usuario))));
                                                },
                                                  child: const Text(
                                                      "Confirmar"),
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    primary: Colors.black26,
                                                    onPrimary: Colors.white,
                                                    elevation: 0,
                                                  ),
                                                ),
                                                ElevatedButton(onPressed: () =>
                                                    Navigator.pop(
                                                        context, 'Cancel'),
                                                  child: const Text("Cancelar"),
                                                  style:
                                                  ElevatedButton.styleFrom(
                                                    primary: Colors.teal,
                                                    onPrimary: Colors.white,
                                                    elevation: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    child: Icon(Icons.remove_circle,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.zero,
                                              )
                                          )
                                      ),
                                  ),
                                  color: Colors.black12,
                                ),
                                ),
                                Expanded(child:
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  "Editar estado do aviso?"),
                                              content: const Text(
                                                  "Deseja editar o aviso selecionado?"),
                                              actions: [
                                                ElevatedButton(onPressed: () {
                                                  if (avisos[index].estado ==
                                                      1) {
                                                    avisos[index].estado = 2;
                                                    ac.editarEstadoAviso(
                                                        avisos[index])
                                                        .whenComplete(() =>
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    MeusAvisos(
                                                                        usuario))));
                                                  } else {
                                                    avisos[index].estado = 1;
                                                    ac.editarEstadoAviso(
                                                        avisos[index])
                                                        .whenComplete(() =>
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    MeusAvisos(
                                                                        usuario))));
                                                  }
                                                },
                                                  child: const Text(
                                                      "Confirmar"),
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    primary: Colors.black26,
                                                    onPrimary: Colors.white,
                                                    elevation: 0,
                                                  ),
                                                ),
                                                ElevatedButton(onPressed: () =>
                                                    Navigator.pop(
                                                        context, 'Cancel'),
                                                  child: const Text("Cancelar"),
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    primary: Colors.teal,
                                                    onPrimary: Colors.white,
                                                    elevation: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    child: Icon(Icons.edit,
                                      size: 30,
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            )
                                        )
                                    ),
                                  ),
                                  color: Colors.black12,
                                ),
                                )
                              ]
                          ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: avisos.length,
              );
            } else if(!buscaRealizada && avisos.length <= 0){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                    ),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Carregando seus avisos',
                      style: TextStyle(
                          color: Colors.teal
                      ),
                    ),
                  )
                ],
              );
            } else{
              return Container(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
                child: Text("Você não possui nenhum aviso cadastrado.",
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currendIndex,
        iconSize: 40,
        backgroundColor: Colors.teal,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.white,),
            label: 'Mapa',
          ),
        ],
        onTap: (index){
          setState(() {
            _currendIndex = index;
            bottomNavigator(_currendIndex);
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
  void onSelected(BuildContext context, int item){
    switch(item){
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MeusAvisos(usuario) ));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MeusAnimais(usuario) ));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => UsuarioPerfil(usuario) ));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginUsuario() ));
        break;
    }
  }

  bottomNavigator(int index){
    if(index==0){
      Navigator.push(context, MaterialPageRoute(builder: (context) => AvisosListagem(usuario)));
    }
    if(index==1){
      Navigator.push(context, MaterialPageRoute(builder: (context) => MapaAvisosView() ));
    }
  }


  estadoAviso(int? estado){
    if(estado==1){
      return "desaparecido".toUpperCase();
    }
    if(estado==2){
      return "encontrado".toUpperCase();
    }
  }

  corAviso(int? estado){
    if(estado==1){
      return Colors.yellowAccent;
    }
    if(estado==2){
      return Colors.green;
    }
  }

}

