import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mine_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:mine_manager/blocs/register_bloc/register_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/register_bloc/register_event.dart';
import '../blocs/register_bloc/register_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final RegisterBloc registerBloc = BlocProvider.of<RegisterBloc>(context);
    final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            authBloc.add(AuthLoggedIn());
          }
          if (state is RegisterFailure) {
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
        },
        builder: (context, state) {
          return FormBuilder(
            key: fbKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FormBuilderTextField(
                    name: 'username',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nom d'utilisateur",
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est obligatoire'),
                    ]),
                    onChanged: (value) =>
                        registerBloc.add(RegisterUsernameChanged(value!)),
                  ),
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
                        registerBloc.add(RegisterEmailChanged(value!)),
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
                        registerBloc.add(RegisterPasswordChanged(value!)),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FormBuilderTextField(
                    name: 'confirmPassword',
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirmer le mot de passe',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est obligatoire'),
                    ]),
                    onChanged: (value) => registerBloc
                        .add(RegisterConfirmPasswordChanged(value!)),
                  ),
                ),
                const SizedBox(height: 20),
                state is RegisterLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    if (fbKey.currentState!.validate()) {
                      fbKey.currentState!.save();
                      registerBloc.add(RegisterSubmitted());
                    }
                  },
                  child: const Text("S'inscrire"),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Déjà inscrit ?'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
