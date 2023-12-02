import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/services_auth/auth_exceptions.dart';
import 'package:AirTours/utilities/show_error.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:flutter/material.dart';
import '../../services_auth/firebase_auth_provider.dart';

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  late final TextEditingController _password;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text('Update Password'),
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
                    controller: _password,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password,
                          color: Colors.green), //new line(prefixIcon)
                      border: InputBorder.none,
                      labelText: 'New Password',
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
                      if (value!.isEmpty) {
                        return 'Enter a Valid Password';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 13.0),
                GestureDetector(
                  onTap: () async {
                    bool isSuccessful = false;
                    setState(() {
                      if (formKey.currentState!.validate()) {
                        isSuccessful = true;
                      }
                    });
                    if (isSuccessful) {
                      String newPassword = _password.text;
                      if (newPassword.isNotEmpty) {
                        try {
                          await FirebaseAuthProvider.authService()
                              .updateUserPassword(password: newPassword);
                          await showSuccessDialog(
                              context, 'Information Updated');
                          await FirebaseAuthProvider.authService().logOut();
                          await Navigator.of(context).pushNamed(loginRoute);
                        } on WeakPasswordAuthException {
                          await showErrorDialog(context, 'Weak Password');
                        } on GenericAuthException {
                          await showErrorDialog(context, 'Updating Error');
                        }
                      } else {
                        await showErrorDialog(
                            context, 'Please Write The New Password');
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
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
                      'Update!',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () async {
                    await Navigator.of(context)
                        .pushNamedAndRemoveUntil(bottomRoute, (route) => false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
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
                      'Cancel',
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
