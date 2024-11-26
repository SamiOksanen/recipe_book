import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_state.dart';
import 'package:recipe_book/widgets/enter-listener.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onSignUpComplete;

  const SignUpPage({Key? key, required this.onSignUpComplete})
      : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _error;

  void _signUp() {
    final appState = Provider.of<AppState>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _error = 'Invalid email format';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _error = 'Passwords do not match';
      });
      return;
    }

    if (appState.signUp(email, password)) {
      widget.onSignUpComplete();
    } else {
      setState(() {
        _error = 'User already exists';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            EnterListener(
              onEnter: _signUp,
              child: TextField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
                onPressed: _signUp,
                icon: const Icon(Icons.app_registration),
                label: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
