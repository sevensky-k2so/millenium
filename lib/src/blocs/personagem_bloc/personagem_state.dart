import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:millenium/src/models/personagem/personagem.dart';

@immutable
abstract class PersonagemState extends Equatable {
  @override
  List<Object> get props => [];
}

class PersonagemInitial extends PersonagemState {
  @override
  String toString() => 'PersonagemInitial';
}

class PersonagemCarregando extends PersonagemState {
  @override
  String toString() => 'PersonagemCarregando';
}

class PersonagemCarregado extends PersonagemState {
  final Personagem personagem;

  PersonagemCarregado({@required this.personagem});

  @override
  List<Object> get props => [this.personagem];

  @override
  String toString() => 'PersonagemCarregado';
}

class PersonagensCarregado extends PersonagemState {
  final List<Personagem> personagens;

  PersonagensCarregado({@required this.personagens});

  @override
  List<Object> get props => [this.personagens];

  @override
  String toString() => 'PersonagensCarregado';
}

class PersonagemAtualizado extends PersonagemState {
  final String mensagem;

  PersonagemAtualizado({this.mensagem: ""});

  @override
  List<Object> get props => [this.mensagem];

  @override
  String toString() => 'PersonagemAtualizado';
}

class PersonagemRemovido extends PersonagemState {
  final String mensagem;

  PersonagemRemovido({@required this.mensagem});

  @override
  List<Object> get props => [this.mensagem];

  @override
  String toString() => 'PersonagemRemovido';
}

class PersonagemSuccess extends PersonagemState {
  final String mensagem;

  PersonagemSuccess({this.mensagem: ""});

  @override
  List<Object> get props => [this.mensagem];

  @override
  String toString() => 'PersonagemSuccess';
}

class PersonagemFailure extends PersonagemState {
  final String erro;

  PersonagemFailure({@required this.erro});

  @override
  List<Object> get props => [this.erro];

  @override
  String toString() => 'PersonagemFailure';
}
