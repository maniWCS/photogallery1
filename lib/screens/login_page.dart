import 'package:flutter/material.dart';
import 'package:photogallery1/services/auth_credentials.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<LoginCredentials> didProvideCredentials;
  final VoidCallback shouldShowSignUp;

  LoginPage(
      {Key? key,
      required this.didProvideCredentials,
      required this.shouldShowSignUp})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 2
    return Scaffold(
      // 3
      body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 40),
          // 4
          child: Stack(children: [
            // Login Form
            _loginForm(),

            // 6
            // Sign Up Button
            Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: widget.shouldShowSignUp,
                child: const Text('Don\'t have an account? Sign up.'),
              ),

              // FlatButton(
              //     onPressed: () {},
              //     child: Text('Don\'t have an account? Sign up.')),
            ),
          ])),
    );
  }

  // 5
  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Username TextField
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
              icon: Icon(Icons.mail), labelText: 'Username'),
        ),

        // Password TextField
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),

        // Login Button
        // FlatButton(
        //     onPressed: _login,
        //     child: Text('Login'),
        //     color: Theme.of(context).accentColor),
        ElevatedButton(
          onPressed: _login,
          child: const Text('Login'),
        ),
      ],
    );
  }

  // 7
  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $username');
    print('password: $password');

    final credentials =
        LoginCredentials(username: username, password: password);
    widget.didProvideCredentials(credentials);
  }
}
