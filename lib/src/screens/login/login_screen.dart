import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:millenium/src/blocs/login_bloc/login_bloc.dart';
import 'package:millenium/src/repository/usuario_repository.dart';
import 'package:millenium/src/screens/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  final UsuarioRepository _usuarioRepository;

  LoginScreen({@required UsuarioRepository repository})
      : assert(repository != null),
        _usuarioRepository = repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(repository: _usuarioRepository),
      child: LoginForm(),
    );
  }
}
