import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:millenium/src/blocs/login_bloc/login_event.dart';
import 'package:millenium/src/blocs/login_bloc/login_state.dart';
import 'package:millenium/src/repository/usuario_repository.dart';

import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UsuarioRepository _usuarioRepository;

  LoginBloc({
    @required repository,
  })  : assert(repository != null),
        _usuarioRepository = repository;

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is Autenticar) {
      yield* this._mapAutenticarToState(email: event.email, senha: event.senha);
    }
  }

  Stream<LoginState> _mapAutenticarToState(
      {String email, String senha}) async* {
    yield LoginCarregando();
    try {
      await _usuarioRepository.efetuarLogin(email: email, senha: senha);
      yield LoginSuccess(
        usuario: await _usuarioRepository.obterUsuario(),
      );
    } catch (_) {
      yield LoginFailure(erro: "Erro ao autenticar.\nVerifique sua conexão.");
    }
  }
}
