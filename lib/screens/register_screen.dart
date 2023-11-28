import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _username = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await AuthService().register(_email, _username, _password);

      if (response.statusCode == 201) {
        if(mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } else {
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
              decoration: const InputDecoration(labelText: 'Username'),
              onSaved: (value) => _username = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSaved: (value) => _password = value!,
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
