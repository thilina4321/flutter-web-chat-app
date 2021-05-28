import 'package:flutter/material.dart';

class AuthWidget extends StatefulWidget {
  final Function(String email, String userName, String password, bool isLoading,
      BuildContext context) submitFn;
  final bool isLoading;

  AuthWidget({required this.submitFn, required this.isLoading});

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;

  String email = '';
  String userName = '';
  String password = '';

  login() {
    _formKey.currentState!.save();
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();
    widget.submitFn(email, userName, password, isLogin, context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onSaved: (value) {
                        email = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      key: ValueKey('email'),
                      maxLines: null,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    if (!isLogin)
                      TextFormField(
                        onSaved: (value) {
                          userName = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'User Name is required';
                          }
                          return null;
                        },
                        key: ValueKey('userName'),
                        decoration: InputDecoration(labelText: 'User Name'),
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                      onSaved: (value) {
                        password = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      MaterialButton(
                        color: Colors.blue,
                        onPressed: login,
                        child: isLogin ? Text('Login') : Text('Sign up'),
                      ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: isLogin
                          ? Text('Create an account')
                          : Text('Already have an account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
