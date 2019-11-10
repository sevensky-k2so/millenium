import 'package:json_annotation/json_annotation.dart';
import 'package:millenium/src/models/atributos_combate/atributos_combate.dart';
import 'package:millenium/src/models/atributos_exploracao/atributos_exploracao.dart';
import 'package:millenium/src/models/consumivel/consumivel.dart';
import 'package:millenium/src/models/equipamento/arma/arma.dart';
import 'package:millenium/src/models/equipamento/armadura/armadura.dart';
import 'package:millenium/src/models/item/item.dart';

part 'personagem.g.dart';

@JsonSerializable()
class Personagem {
  String imagem;
  String jogadorId;
  String id;
  String nome;
  int vida;
  int vidaAtual;
  int energia;
  int energiaAtual;
  int mana;
  int manaAtual;
  int fome;
  int level;
  int xp;
  AtributosCombate atributosCombate;
  AtributosExploracao atributosExploracao;
  List bolsa;
  List equipamentos;

  Personagem({
    this.imagem,
    this.jogadorId,
    this.id,
    this.nome,
    this.vida: 20,
    this.vidaAtual: 20,
    this.energia: 6,
    this.energiaAtual: 6,
    this.mana: 0,
    this.manaAtual: 0,
    this.fome: 5,
    this.level: 1,
    this.xp: 0,
    this.atributosCombate,
    this.atributosExploracao,
    this.bolsa: const [],
    this.equipamentos: const [],
  });

  factory Personagem.fromJson(Map<String, dynamic> json) =>
      _$PersonagemFromJson(json);

  Map<String, dynamic> toJson() => _$PersonagemToJson(this);

  int vidaTotal() {
    return this.vida + 5 * this.atributosCombate.vitality;
  }

  int energiaTotal() {
    return this.energia + 2 * (this.atributosCombate.vitality / 5).floor();
  }

  int manaTotal() {
    return this.mana;
  }

  int dano() {
    int dano;

    equipamentos.forEach((item) {
      if (item is Arma) {
        dano = item.dano;
      }
    });

    return dano ?? 0;
  }

  int defesa() {
    int defesa = 0;

    equipamentos.forEach((item) {
      if (item is Armadura) {
        defesa += item.defesa;
      }
    });
    return defesa;
  }

  @override
  String toString() => "Personagem { id: $id}";
}