import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/services_auth/auth_exceptions.dart';
import 'package:AirTours/utilities/show_error.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/firebase_auth_provider.dart';

class UpdateEmailView extends StatefulWidget {
  const UpdateEmailView({super.key});

  @override
  State<UpdateEmailView> createState() => _UpdateEmailViewState();
}

class _UpdateEmailViewState extends State<UpdateEmailView> {
  late final TextEditingController _email;
  final FirebaseCloudStorage c = FirebaseCloudStorage();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text('Update Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  //new line (container and all of it is inside)
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 8, right: 8), //0
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 13, 213,
                            130), //new line(border) and(color) Green color
                      ),
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.white),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email,color: Colors.green), //new line(prefixIcon)
                      border: InputBorder.none,
                      labelText: 'New Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z]+\.(com)$').hasMatch(value)) {
                        return 'Enter correct email';
                      } else {
                        return null;
                      } 
                    },
                  
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    bool isSuccessful = false;
                    setState(() {
                      if (formKey.currentState!.validate()) {
                          isSuccessful = true;
                        }
                      });
                    if (isSuccessful) {
                    String newEmail = _email.text;
                    try {
                      await FirebaseAuthProvider.authService()
                          .updateUserEmail(email: newEmail);

                      final String currentUser =
                          FirebaseAuthProvider.authService().currentUser!.id;
                      c.updateUser(
                          ownerUserId: currentUser,
                          email: newEmail,
                          phoneNum: "0580647715");
                      await showSuccessDialog(context, 'Information Updated');
                      await FirebaseAuthProvider.authService().logOut();
                      await Navigator.of(context).pushNamed(loginRoute);
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(context, 'Email Already Used');
                    } on InvalidEmailAuthException {
                      await showErrorDialog(context, 'Invalid Email');
                    } on GenericAuthException {
                      await showErrorDialog(context, 'Updating Error');
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
                      'Update!',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                   await Navigator.of(context)
                      .pushNamedAndRemoveUntil(bottomRoute, (route) => false);
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







