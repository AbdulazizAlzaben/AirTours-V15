import 'package:flutter/material.dart';

import '../../constants/pages_route.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/button.dart';
import '../../utilities/show_error.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isSecurePassword = true; //new line(_isSecurePassword)
  bool _isSecurePassword2 = true;
  final FirebaseCloudStorage c = FirebaseCloudStorage();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _password2;
  late final TextEditingController _phoneNum;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _password2 = TextEditingController();
    _phoneNum = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _password2.dispose();
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

  Widget togglePassword2() {
    //new widget (togglePassword)
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword2 = !_isSecurePassword2;
        });
      },
      icon: _isSecurePassword2
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
      backgroundColor: Colors.white, //change color to white
      body: Form(
        key: _formKey,
        child: Center(
          //create center widget
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.asset('images/AirTours-5.png'), //change image
                  ), //delet text contain('AirTours')
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                        ),
                        border: InputBorder.none,
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
                  const SizedBox(height: 10), //change height to 10
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, //change color to white
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter password";
                        }
                        // Add a check for the minimum length of the password
                        if (value.length < 6) {
                          return "Password must be at least 6 characters long";
                        } else {
                          return null;
                        }
                      },
                      //textAlign: TextAlign.center,
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
                  const SizedBox(height: 10), //change height to 10
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, //change color to white
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter password";
                        }
                        if (_password.text != _password2.text) {
                          return "Password doesn't match!";
                        } else {
                          return null;
                        }
                      },
                      //textAlign: TextAlign.center,
                      controller: _password2,
                      obscureText: _isSecurePassword, //new line (obscureText)
                      decoration: InputDecoration(
                        border: InputBorder.none, //new line(border)
                        prefixIcon: const Icon(
                          Icons.key,
                          color: Colors.green,
                        ), //new line(prefixIcon)
                        labelText: 'Confirm Password',
                        suffixIcon: togglePassword2(), //new line(suffixIcon)
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, //change color to white
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter phone number";
                        }

                        // Add a simple check for a valid phone number pattern
                        final phoneRegex = RegExp(r'^05\d{8}$');
                        if (!phoneRegex.hasMatch(value)) {
                          return "Enter a valid 10-digit phone number";
                        } else {
                          return null;
                        }
                      },
                      controller: _phoneNum,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.green,
                        ), //new line(prefixIcon)
                        border: InputBorder.none,
                        labelText: 'Phone Number 05********',
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
                  const SizedBox(height: 10), //change height to 10
                  MyButton(
                      title: 'Register',
                      onPressed: () async {
                        bool isSuccessful = false;
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            isSuccessful = true;
                          }
                        });
                        if (isSuccessful) {
                          final email = _email.text;
                          try {
                            await FirebaseAuthProvider.authService().createUser(
                                email: email, password: _password.text);

                            final String userId =
                                FirebaseAuthProvider.authService()
                                    .currentUser!
                                    .id;
                            final String currentEmail =
                                FirebaseAuthProvider.authService()
                                    .currentUser!
                                    .email;
                            c.createNewUser(
                                ownerUserId: userId,
                                email: currentEmail,
                                phoneNum: _phoneNum.text,
                                balance: 0.0);
                            FirebaseAuthProvider.authService()
                                .sendEmailVerification();
                            await Navigator.of(context)
                                .pushNamed(verficationRoute);
                          } on WeakPasswordAuthException {
                            await showErrorDialog(context, 'Weak password');
                          } on EmailAlreadyInUseAuthException {
                            await showErrorDialog(
                                context, 'Email already in use');
                          } on InvalidEmailAuthException {
                            await showErrorDialog(
                                context, 'This is an invalid email');
                          } on GenericAuthException {
                            await showErrorDialog(
                                context, 'Failed to register');
                          }
                        }
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already Registered?'),
                      TextButton(
                          onPressed: () async {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoute, (route) => false);
                          },
                          child: const Text('Login Here'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
