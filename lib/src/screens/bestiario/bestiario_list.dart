import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:millenium/src/blocs/bestiario_bloc/bestiario_bloc.dart';
import 'package:millenium/src/blocs/bestiario_bloc/bestiario_state.dart';
import 'package:millenium/src/components/app_bar.dart';
import 'package:millenium/src/components/tiles/bestiario_tile.dart';
import 'package:millenium/src/components/search.dart';
import 'package:millenium/src/models/besta/besta.dart';
import 'package:millenium/src/models/filtro_bestiario.dart';
import 'package:millenium/src/models/usuario.dart';
import 'package:millenium/src/screens/bestiario/filtro_bestiario_form.dart';
import 'package:millenium/src/screens/error_screen.dart';
import 'package:millenium/src/screens/loading_screen.dart';

class BestiarioList extends StatefulWidget {
  final Usuario usuario;
  BestiarioList({@required this.usuario});

  @override
  _BestiarioListState createState() => _BestiarioListState(usuario: usuario);
}

class _BestiarioListState extends State<BestiarioList> {
  final Usuario usuario;
  _BestiarioListState({@required this.usuario});

  FiltroBestiario filtro;
  String resultadoPesquisa = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<BestiarioBloc, BestiarioState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: CustomAppBar(
          titulo: "Bestiário",
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.search),
              onPressed: onSearch,
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.filter),
              onPressed: onFilter,
            ),
          ],
        ),
        body: BlocBuilder<BestiarioBloc, BestiarioState>(
          builder: (context, state) {
            if (state is BestiarioCarregado) {
              return BestiarioTile(filtrar(state.bestiario));
            } else if (state is BestiarioCarregando) {
              return LoadingScreen();
            } else if (state is BestiarioFailure) {
              return ErroScreen();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void onSearch() async {
    resultadoPesquisa = await showSearch(context: context, delegate: Search());

    if (resultadoPesquisa == null) {
      resultadoPesquisa = "";
    }

    setState(() {});
  }

  void onFilter() async {
    showDialog(
      context: context,
      builder: (dialogContext) => FiltroBestiarioForm(
        filtro: filtro,
        onChanged: (filtro) {
          if (filtro == null) {
            setState(() {
              this.filtro = filtro;
              resultadoPesquisa = "";
            });
          } else {
            setState(() {
              this.filtro = filtro;
            });
          }
        },
      ),
    );
  }

  List<Besta> filtrar(List<Besta> bestiario) {
    if (resultadoPesquisa.isNotEmpty) {
      return bestiario
          .where((besta) => besta.nome
              .toLowerCase()
              .contains(resultadoPesquisa.toLowerCase()))
          .toList();
    }

    if (filtro != null) {
      return filtro.filtrar(bestiario);
    }

    return bestiario;
  }
}
