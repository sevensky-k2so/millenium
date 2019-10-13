import 'package:flutter/material.dart';
import 'package:millenium/src/models/personagem.dart';
import 'package:millenium/src/screens/login_screen.dart';
import 'package:millenium/src/screens/personagem_screen/personagem_screen.dart';
import 'package:millenium/src/util/util.dart';

class PersonagemTile extends StatelessWidget {
  final Personagem personagem;

  PersonagemTile({this.personagem});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 40,
            ),
            title: Text(
              personagem.nome,
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Vida: ${personagem.vidaAtual}/${personagem.vidaTotal()}"),
                Text(
                    "Energia: ${personagem.energiaAtual}/${personagem.energiaTotal()}"),
              ],
            ),
            onTap: () {
              navigateTo(
                context,
                PersonagemScreen(
                  personagem: this.personagem,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}