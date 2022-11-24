import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

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
  final _emailController = TextEditingController();
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

    if (_authMode == AuthMode.login) {
      // Log user in
      await context.read<AuthProvider>().login(
            _authData['email']!,
            _authData['password']!,
          );
    } else {
      // Sign user up
      await context.read<AuthProvider>().signUp(
            _authData['email']!,
            _authData['password']!,
          );
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
    var local = AppLocalizations.of(context)!;
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                local.login_to_account,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      labelText: local.email,
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? local.enter_valid_email
                            : null,
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: local.password,
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autofocus: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordController,
                    validator: (password) =>
                        password != null && password.length < 6
                            ? local.password_is_too_short
                            : null,
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
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
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: _authMode == AuthMode.signUp,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.lock),
                              labelText: local.confirm_password,
                              border: InputBorder.none,
                            ),
                            obscureText: true,
                            validator: _authMode == AuthMode.signUp
                                ? (value) {
                                    if (value != _passwordController.text) {
                                      return local.passwords_do_not_match;
                                    }
                                    return null;
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
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
                child: Text(_authMode == AuthMode.login
                    ? local.sign_in
                    : local.sign_up),
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
                child: Text(_authMode == AuthMode.login
                    ? local.sign_up_instead
                    : local.sign_in_instead),
              ),
              const Divider(),
              Text(local.or),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                    size: 36,
                  ),
                  onPressed: () => context.read<AuthProvider>().googleLogin(),
                  label: Text(local.sign_up_with_google),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.apple,
                    color: Colors.black,
                    size: 36,
                  ),
                  onPressed: () => context.read<AuthProvider>().googleLogin(),
                  label: Text(local.sign_up_with_apple),
                ),
              ),
            ],
          ),
        ));
  }
}
