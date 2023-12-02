import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/show_error.dart';

class LoginForDelete extends StatefulWidget {
  const LoginForDelete({super.key});

  @override
  State<LoginForDelete> createState() => _LoginForDeleteState();
}

class _LoginForDeleteState extends State<LoginForDelete> {
  bool _isSecurePassword = true; //new line(_isSecurePassword)
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  final FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
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
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text('Login To Verify It Is You'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Colors.green,
                      ), //new line(prefixIcon)
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
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z]+\.(com)$')
                              .hasMatch(value)) {
                        return 'Enter correct email';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 3.0),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _password,
                    obscureText: _isSecurePassword, //new line(obscureText)
                    decoration: InputDecoration(
                      border: InputBorder.none, //new line(border)
                      prefixIcon: const Icon(
                        Icons.key,
                        color: Colors.green,
                      ), //new line(prefixIcon)
                      hintText: 'Password',
                      suffixIcon: togglePassword(),
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
                      ), //new line(suffixIcon)
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a Valid Password';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 5.0),
                GestureDetector(
                  onTap: () async {
                    bool isSuccessful = false;
                    setState(() {
                      if (formKey.currentState!.validate()) {
                        isSuccessful = true;
                      }
                    });
                    if (isSuccessful) {
                      try {
                        await FirebaseAuthProvider.authService().logIn(
                            email: _email.text, password: _password.text);
                        final userId =
                            FirebaseAuthProvider.authService().currentUser!.id;
                        await c.deleteUser(ownerUserId: userId);
                        await showSuccessDialog(context, 'Account Deleted');
                        await Navigator.of(context).pushNamedAndRemoveUntil(
                            welcomeRoute, (route) => false);
                      } on UserNotFoundAuthException {
                        await showErrorDialog(context, 'User not found');
                      } on WrongPasswordAuthException {
                        await showErrorDialog(context, 'Wrong credentials');
                      } on GenericAuthException {
                        await showErrorDialog(context, 'Authentication Error');
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 1,
                              offset: Offset(0, 0)) //change blurRadius
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 13, 213, 130)),
                    child: const Center(
                        child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
