import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:millenium/src/blocs/authentication_bloc/authentication_event.dart';
import 'package:millenium/src/models/usuario.dart';
import 'package:millenium/src/blocs/authentication_bloc/authentication_bloc.dart';

class CustomDrawer extends StatelessWidget {
  final Usuario _usuario;

  CustomDrawer({@required Usuario usuario})
      : assert(usuario != null),
        _usuario = usuario;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(_usuario.nome),
              accountEmail: Text(_usuario.email),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(),
                onTap: () {},
              )),
          ListTile(
            title: Text("Personagens"),
            onTap: () {
              Navigator.of(context).pop();
              if (this._usuario.isAdmin) {
                Navigator.of(context).pushNamed(
                  "/todosPersonagemScreen",
                  arguments: this._usuario,
                );
              } else {
                Navigator.of(context).pushNamed(
                  "/meusPersonagensScreen",
                  arguments: this._usuario,
                );
              }
            },
          ),
          ListTile(
            title: Text("Loja"),
          ),
          ListTile(
            title: Text("História"),
          ),
          ListTile(
            title: Text("Classes"),
            onTap: () {
              Navigator.of(context).popAndPushNamed("/classesScreen");
            },
          ),
          ListTile(
            title: Text("Bestiário"),
            onTap: () {
              Navigator.of(context).popAndPushNamed("/bestiarioScreen");
            },
          ),
          ListTile(
            title: Text("Regras do Jogo"),
          ),
          ListTile(
            title: Text("Minha Conta"),
          ),
          ListTile(
            title: Text("Sair"),
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .dispatch(LoggedOut());
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/loginScreen", (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
