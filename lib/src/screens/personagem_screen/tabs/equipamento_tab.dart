import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:millenium/src/blocs/personagem_bloc/personagem_event.dart';
import 'package:millenium/src/blocs/personagem_bloc/personagem_state.dart';
import 'package:millenium/src/components/form/text_field.dart';
import 'package:millenium/src/components/list/bolsa_tile.dart';
import 'package:millenium/src/models/consumivel/consumivel.dart';
import 'package:millenium/src/models/equipamento/arma/arma.dart';
import 'package:millenium/src/models/equipamento/armadura/armadura.dart';
import 'package:millenium/src/models/item/item.dart';
import 'package:millenium/src/models/personagem/personagem.dart';
import 'package:millenium/src/models/usuario.dart';
import 'package:millenium/src/blocs/personagem_bloc/personagem_bloc.dart';
import 'package:millenium/src/screens/error_screen.dart';
import 'package:millenium/src/screens/loading_screen.dart';
import 'package:millenium/src/validators/equipamento_validator.dart';

class EquipamentoTab extends StatefulWidget {
  final Usuario usuario;
  final Personagem personagem;

  EquipamentoTab({@required this.usuario, @required this.personagem});

  @override
  _EquipamentoTabState createState() =>
      _EquipamentoTabState(usuario: usuario, personagem: personagem);
}

class _EquipamentoTabState extends State<EquipamentoTab> {
  final Usuario usuario;
  Personagem personagem;

  _EquipamentoTabState({@required this.usuario, @required this.personagem});

  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() async {
    BlocProvider.of<PersonagemBloc>(context)
        .dispatch(ObterPersonagem(idPersonagem: personagem.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonagemBloc, PersonagemState>(
      listener: (context, state) {
        if (state is Success) {
          BlocProvider.of<PersonagemBloc>(context)
              .dispatch(ObterPersonagem(idPersonagem: personagem.id));
        }
        if (state is PersonagemLoaded) {
          setState(() {
            personagem = state.personagem;
          });
        }
      },
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Stack(
          children: <Widget>[
            BlocBuilder<PersonagemBloc, PersonagemState>(
              builder: (context, state) {
                if (state is Failure) {
                  return ErroScreen();
                } else if (state is Loading) {
                  return LoadingScreen();
                } else {
                  return BolsaTile(
                    isNotAdmin: !usuario.isAdmin,
                    bolsa: personagem.bolsa,
                    onDismissed: (item) {
                      personagem.bolsa.remove(item);
                      BlocProvider.of<PersonagemBloc>(context).dispatch(
                        AtualizarPersonagem(personagem: personagem),
                      );
                      setState(() {
                        personagem = personagem;
                      });
                    },
                    onEquiped: (item) {
                      dynamic arma;
                      personagem.equipamentos.forEach((itemEquiped) {
                        if (itemEquiped.tipo == "Arma") {
                          arma = itemEquiped;
                        }
                      });
                      personagem.equipamentos.remove(arma);
                      personagem.equipamentos.add(item);
                      BlocProvider.of<PersonagemBloc>(context).dispatch(
                        AtualizarPersonagem(personagem: personagem),
                      );
                      setState(() {
                        personagem = personagem;
                      });
                    },
                    onUtilizar: (item) {
                      if (personagem.vidaTotal() <
                          personagem.vidaAtual + item.vida) {
                        personagem.vidaAtual = personagem.vidaTotal();
                      } else {
                        personagem.vidaAtual += item.vida;
                      }

                      if (personagem.energiaTotal() <
                          personagem.energiaAtual + item.energia) {
                        personagem.energiaAtual = personagem.energiaTotal();
                      } else {
                        personagem.energiaAtual += item.energia;
                      }

                      if (personagem.manaTotal() <
                          personagem.manaAtual + item.mana) {
                        personagem.manaAtual = personagem.manaTotal();
                      } else {
                        personagem.manaAtual += item.mana;
                      }

                      personagem.bolsa.remove(item);

                      BlocProvider.of<PersonagemBloc>(context).dispatch(
                        AtualizarPersonagem(personagem: personagem),
                      );
                      setState(() {
                        personagem = personagem;
                      });
                    },
                  );
                }
              },
            ),
            Visibility(
              visible: this.usuario.isAdmin,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (contextMessage) {
                          return FormCadastroItem(
                            personagem: personagem,
                            onSaved: (personagem) {
                              BlocProvider.of<PersonagemBloc>(context).dispatch(
                                AtualizarPersonagem(
                                  personagem: this.personagem,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef PersonagemCallback(Personagem personagem);

class FormCadastroItem extends StatefulWidget {
  final Personagem personagem;
  final PersonagemCallback onSaved;

  FormCadastroItem({@required this.personagem, @required this.onSaved});

  @override
  _FormCadastroItemState createState() =>
      _FormCadastroItemState(personagem: personagem, onSaved: onSaved);
}

class _FormCadastroItemState extends State<FormCadastroItem> {
  final Personagem personagem;
  final PersonagemCallback onSaved;

  _FormCadastroItemState({@required this.personagem, @required this.onSaved});

  String dropdownItemValue = 'Item';
  String dropdownEquipamentoValue = 'Médio';
  final tiposItem = ['Item', 'Arma', 'Armadura', 'Consumível'];
  final tiposEquipamento = ['Pesado', 'Médio', 'Leve'];

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _danoDefesaController = TextEditingController();
  final _vidaController = TextEditingController();
  final _energiaController = TextEditingController();
  final _manaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _danoDefesaController.text = "0";
    _vidaController.text = "0";
    _energiaController.text = "0";
    _manaController.text = "0";
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _danoDefesaController.dispose();
    _vidaController.dispose();
    _energiaController.dispose();
    _manaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Novo Item"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButton<String>(
                value: dropdownItemValue,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownItemValue = newValue;
                  });
                },
                items: tiposItem.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width: 208,
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
              CustomTextField(
                labelText: "Nome",
                controller: _nomeController,
                validator: EquipamentoValidator.isNotEmpty,
              ),
              _buildVariantsInputs(dropdownItemValue),
              CustomTextField(
                hintText: "Descrição",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
                maxLines: 5,
                controller: _descricaoController,
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Voltar",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: _onSalvarEquipamento,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVariantsInputs(String value) {
    switch (value) {
      case 'Arma':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButton<String>(
              value: dropdownEquipamentoValue,
              onChanged: (String newValue) {
                setState(() {
                  dropdownEquipamentoValue = newValue;
                });
              },
              items: tiposEquipamento
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: 208,
                    child: Text(value),
                  ),
                );
              }).toList(),
            ),
            CustomTextField(
              labelText: "Dano",
              controller: _danoDefesaController,
              keyboardType: TextInputType.number,
              validator: EquipamentoValidator.isNotEmpty,
            ),
          ],
        );
      case 'Armadura':
        return Column(
          children: <Widget>[
            DropdownButton<String>(
              value: dropdownEquipamentoValue,
              onChanged: (String newValue) {
                setState(() {
                  dropdownEquipamentoValue = newValue;
                });
              },
              items: tiposEquipamento
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: 208,
                    child: Text(value),
                  ),
                );
              }).toList(),
            ),
            CustomTextField(
              labelText: "Defesa",
              controller: _danoDefesaController,
              keyboardType: TextInputType.number,
              validator: EquipamentoValidator.isNotEmpty,
            ),
          ],
        );
      case 'Consumível':
        return Row(
          children: [
            Expanded(
              child: CustomTextField(
                labelText: "Vida",
                controller: _vidaController,
                keyboardType: TextInputType.number,
                validator: EquipamentoValidator.isNotEmpty,
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: CustomTextField(
                labelText: "Energia",
                controller: _energiaController,
                keyboardType: TextInputType.number,
                validator: EquipamentoValidator.isNotEmpty,
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: CustomTextField(
                labelText: "Mana",
                controller: _manaController,
                keyboardType: TextInputType.number,
                validator: EquipamentoValidator.isNotEmpty,
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  void _onSalvarEquipamento() {
    bool isFormValid = _formKey.currentState.validate();
    if (isFormValid) {
      Navigator.of(context).pop();
      switch (dropdownItemValue) {
        case 'Arma':
          final Arma arma = Arma(
            nome: _nomeController.text,
            descricao: _descricaoController.text,
            tipo: dropdownItemValue,
            tipoEquipamento: dropdownEquipamentoValue,
            dano: int.parse(_danoDefesaController.text),
          );
          personagem.bolsa.add(arma);
          break;
        case 'Armadura':
          final Armadura armadura = Armadura(
            nome: _nomeController.text,
            descricao: _descricaoController.text,
            tipo: dropdownItemValue,
            tipoEquipamento: dropdownEquipamentoValue,
            defesa: int.parse(_danoDefesaController.text),
          );
          personagem.bolsa.add(armadura);
          break;
        case 'Consumível':
          final Consumivel consumivel = Consumivel(
            nome: _nomeController.text,
            descricao: _descricaoController.text,
            tipo: dropdownItemValue,
            vida: int.parse(_vidaController.text),
            energia: int.parse(_energiaController.text),
            mana: int.parse(_manaController.text),
          );
          personagem.bolsa.add(consumivel);
          break;
        case 'Item':
          final Item item = Item(
            nome: _nomeController.text,
            descricao: _descricaoController.text,
            tipo: dropdownItemValue,
          );
          personagem.bolsa.add(item);
          break;
      }

      onSaved(personagem);
    }
  }
}
