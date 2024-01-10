import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mine_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:mine_manager/screens/register_screen.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/login_bloc/login_bloc.dart';
import '../blocs/login_bloc/login_event.dart';
import '../blocs/login_bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    var loginBloc = BlocProvider.of<LoginBloc>(context);
    final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Erreur de connexion'),
                content: Text(state.error),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          }
          if (state is LoginSuccess) {
            authBloc.add(AuthLoggedIn());
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          return FormBuilder(
            key: fbKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/MineManagerLogo.png',
                  width: 400,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est obligatoire'),
                      FormBuilderValidators.email(
                          errorText: 'Email invalide'),
                    ]),
                    onChanged: (value) =>
                        loginBloc.add(LoginEmailChanged(value!)),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FormBuilderTextField(
                    name: 'password',
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mot de passe',
                    ),
                    validator: FormBuilderValidators.required(
                        errorText: 'Ce champ est obligatoire'),
                    onChanged: (value) =>
                        loginBloc.add(LoginPasswordChanged(value!)),
                  ),
                ),
                const SizedBox(height: 20),
                state is LoginLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    if (fbKey.currentState!.validate()) {
                      fbKey.currentState!.save();
                      loginBloc.add(LoginSubmitted());
                    }
                  },
                  child: const Text('Se connecter'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const RegisterScreen())),
                  child: const Text('Pas encore de compte ?'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
