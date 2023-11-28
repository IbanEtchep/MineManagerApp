import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await AuthService().login(_email, _password);

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              onSaved: (value) => _email = value!,
              validator: (value) => value!.contains('@') ? null : 'Invalid email',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSaved: (value) => _password = value!,
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: _submit,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Pas de compte ? Inscrivez-vous'),
            ),
          ],
        ),
      ),
    );
  }
}
