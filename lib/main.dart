import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:millenium/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:millenium/src/blocs/authentication_bloc/authentication_event.dart';
import 'package:millenium/src/blocs/authentication_bloc/authentication_state.dart';
import 'package:millenium/src/blocs/bloc_delegate.dart';
import 'package:millenium/src/blocs/usuario_bloc/usuario_bloc.dart';
import 'package:millenium/src/models/usuario.dart';
import 'package:millenium/src/repository/bestiario_repository.dart';
import 'package:millenium/src/repository/personagem_repository.dart';
import 'package:millenium/src/repository/usuario_repository.dart';
import 'package:millenium/src/screens/alterar_senha/alterar_senha_screen.dart';
import 'package:millenium/src/screens/bestiario/bestiario_screen.dart';
import 'package:millenium/src/screens/cadastro/cadastro_screen.dart';
import 'package:millenium/src/screens/classes_screen/classes_screen.dart';
import 'package:millenium/src/screens/error_screen.dart';
import 'package:millenium/src/screens/home_screen.dart';
import 'package:millenium/src/screens/login/login_screen.dart';
import 'package:millenium/src/screens/meus_personagens_screen/meus_personagens_screen.dart';
import 'package:millenium/src/screens/perfil/perfil_screen.dart';
import 'package:millenium/src/screens/splash_screen.dart';
import 'package:millenium/src/screens/todos_personagens/todos_personagens_screen.dart';
import 'package:millenium/src/blocs/personagem_bloc/personagem_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final UsuarioRepository usuarioRepository = UsuarioRepository();

  runApp(BlocProvider(
    create: (context) =>
        AuthenticationBloc(usuarioRepository: usuarioRepository)
          ..add(AppStarted()),
    child: Millenium(),
  ));
}

class Millenium extends StatelessWidget {
  Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonagemBloc>(
          create: (context) =>
              PersonagemBloc(repository: PersonagemRepository()),
        ),
        BlocProvider<UsuarioBloc>(
          create: (context) => UsuarioBloc(repository: UsuarioRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF012F4F),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            } else if (state is Unauthenticated) {
              return LoginScreen(
                repository: UsuarioRepository(),
              );
            } else if (state is Authenticated) {
              if (usuario == null) {
                usuario = state.usuario;
              }
              return HomeScreen(usuario: usuario);
            } else {
              return ErroScreen();
            }
          },
        ),
        routes: {
          "/classesScreen": (context) => ClassesScreen(usuario: usuario),
          "/perfilScreen": (context) => PerfilScreen(usuario: usuario),
          "/alterarSenhaScreen": (context) => AlterarSenhaScreen(),
          "/loginScreen": (context) =>
              LoginScreen(repository: UsuarioRepository()),
          "/cadastroContaScreen": (context) =>
              CadastroScreen(repository: UsuarioRepository()),
          "/meusPersonagensScreen": (context) =>
              MeusPersonagensScreen(usuario: usuario),
          "/todosPersonagemScreen": (context) =>
              TodosPersonagensScreen(usuario: usuario),
          "/bestiarioScreen": (context) => BestiarioScreen(
                usuario: usuario,
                repository: BestiarioRepository(),
              ),
        },
      ),
    );
  }
}
