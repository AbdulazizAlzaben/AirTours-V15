// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../constants/pages_route.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/button.dart';
import '../../utilities/show_error.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isSecurePassword = true; //new line(_isSecurePassword)
  late final TextEditingController _email;
  late final TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Widget togglePassword() {
    //new widget (togglePassword)
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(
              Icons.visibility,
              color: Colors.green,
            )
          : const Icon(
              Icons.visibility_off,
              color: Colors.green,
            ),
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //change to white
      body: Form(
        key: _formKey,
        child: Center(
          //new line(center)
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    child: Image.asset('images/AirTours-5.png'), //new image
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, //change to white
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter email";
                        }
                        final emailRegex = RegExp(
                            r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
                        if (!emailRegex.hasMatch(value)) {
                          return "Enter a valid email";
                        } else {
                          return null;
                        }
                      },
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Colors.green,
                        ), //new line(prefixIcon)
                        border: InputBorder.none, //new line(border)
                        labelText: 'Email',
                        floatingLabelStyle:
                            const TextStyle(color: Colors.green, fontSize: 18),
                        contentPadding: const EdgeInsets.all(20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), //change size to 10
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white), //change color to white
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter password";
                        } else {
                          return null;
                        }
                      },
                      controller: _password,
                      obscureText: _isSecurePassword, //new line(obscureText)
                      decoration: InputDecoration(
                        border: InputBorder.none, //new line(border)
                        prefixIcon: const Icon(
                          Icons.key,
                          color: Colors.green,
                        ), //new line(prefixIcon)
                        labelText: 'Password',
                        suffixIcon: togglePassword(), //new line(suffixIcon)
                        floatingLabelStyle:
                            const TextStyle(color: Colors.green, fontSize: 18),
                        contentPadding: const EdgeInsets.all(20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), //change size to 10
                  MyButton(
                      title: 'Login',
                      onPressed: () async {
                        bool isSuccessful = false;
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            isSuccessful = true;
                          }
                        });
                        if (isSuccessful) {
                          final email = _email.text;
                          final pass = _password.text;
                          try {
                            await FirebaseAuthProvider.authService()
                                .logIn(email: email, password: pass);
                            final user =
                                FirebaseAuthProvider.authService().currentUser;
                            final isUserr =
                                await c.isUser(ownerUserId: user!.id);
                            final isAdminn = await c.isAdmin(email: email);
                            if (isUserr) {
                              if (isAdminn) {
                                if (user.isEmailVerified) {
                                  await Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          createFlightRoute, (route) => false);
                                } else {
                                  await Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          verficationRoute, (route) => false);
                                }
                              } else {
                                if (user.isEmailVerified) {
                                  await Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          bottomRoute, (route) => false);
                                } else {
                                  await Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          verficationRoute, (route) => false);
                                }
                              }
                            } else {
                              await showErrorDialog(context,
                                  'User is Not Registered in the database');
                            }
                          } on UserNotFoundAuthException {
                            await showErrorDialog(context, 'User Not Found');
                          } on WrongPasswordAuthException {
                            await showErrorDialog(context, 'Wrong Credentials');
                          } on GenericAuthException {
                            await showErrorDialog(
                                context, 'Authentication Error');
                          }
                        }
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not Registered? ',
                      ),
                      TextButton(
                          onPressed: () async {
                            await Navigator.of(context).pushNamedAndRemoveUntil(
                                registerRoute, (route) => false);
                          },
                          child: const Text("Register Now"))
                    ],
                  ),
                  TextButton(
                      onPressed: () async {
                        await Navigator.of(context).pushNamed(resetView);
                      },
                      child: const Text("Forgot Password"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
