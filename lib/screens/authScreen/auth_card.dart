import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/httpException.dart/http_exception.dart';
import '../../providers/auth.dart';

enum AuthMode { signUp, login }

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final _authData = <String, String>{
    'email': '',
    'password': '',
  };
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An Error Occurred!'),
              content: Text(message),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Ok'),
                )
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await context.read<Auth>().login(
              _authData['email']!,
              _authData['password']!,
            );
      } else {
        // Sign user up
        await context.read<Auth>().signUp(
              _authData['email']!,
              _authData['password']!,
            );
      }
    } on HttpException catch (error) {
      var errorMsg = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMsg = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMsg = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMsg = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMsg = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMsg = 'Invalid password.';
      }
      _showErrorDialog(errorMsg);
    } catch (error) {
      var errorMsg = 'Could not autheticate you. Please try again later.';

      _showErrorDialog(errorMsg);
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Form(
        key: _formKey,
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.email), labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.lock), labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
            ),
            if (_authMode == AuthMode.signUp)
              AnimatedContainer(
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.signUp ? 120 : 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.signUp,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.signUp
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _submit,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      color: Theme.of(context).primaryTextTheme.button?.color,
                    ),
                  ),
                ),
                child: Text(_authMode == AuthMode.login ? 'SIGN IN' : 'SIGN UP'),
              ),
            TextButton(
              onPressed: _switchAuthMode,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: MaterialStateProperty.all(
                  TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              child: Text(
                  '${_authMode == AuthMode.login ? 'SIGNUP' : 'SIGN IN'} INSTEAD'),
            ),
          ],
        ),
      )),
    );
  }
}
