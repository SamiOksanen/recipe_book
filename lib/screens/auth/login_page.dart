import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_state.dart';
import 'package:recipe_book/widgets/enter-listener.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSignUp;

  const LoginPage({Key? key, required this.onSignUp}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  void _login() {
    final appState = Provider.of<AppState>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;

    if (!appState.login(email, password)) {
      setState(() {
        _error = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            EnterListener(
              onEnter: _login,
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
                onPressed: _login,
                icon: const Icon(Icons.login),
                label: const Text('Login')),
            const SizedBox(height: 8),
            TextButton.icon(
                onPressed: widget.onSignUp,
                icon: const Icon(Icons.app_registration),
                label: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
