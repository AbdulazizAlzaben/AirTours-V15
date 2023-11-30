import 'package:flutter/material.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../utilities/show_error.dart';
import '../../utilities/show_feedback.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _phoneNum;
  final FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _email = TextEditingController();
    _phoneNum = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text('Add Admin'),
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
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.green,
                      ), //new line(prefixIcon)
                      border: InputBorder.none,
                      labelText: 'Email',
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
                      final converted = await c.convertUserToAdmin(
                          email: _email.text, phoneNum: _phoneNum.text);
                      if (converted == 0) {
                        await showSuccessDialog(context, 'Admin Added');
                      } else if (converted == 1) {
                        await showErrorDialog(context, 'Admin Exists');
                      } else {
                        await showErrorDialog(context, 'User Not Found');
                      }
                      setState(() {
                        _email.clear();
                        _phoneNum.clear();
                      });
                      Navigator.pop(context);
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
                      'Add Admin',
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
