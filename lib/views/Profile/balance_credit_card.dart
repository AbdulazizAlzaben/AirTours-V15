import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/constants/user_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/cloud/cloud_storage_exceptions.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/show_feedback.dart';

class ChargeBalance extends StatefulWidget {
  final String balance;

  const ChargeBalance({super.key, required this.balance});

  @override
  State<ChargeBalance> createState() => _ChargeBalanceState();
}

class _ChargeBalanceState extends State<ChargeBalance> {
  final formKey = GlobalKey<FormState>();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardName = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  final user = FirebaseFirestore.instance.collection('user');

  Future<void> toNext() async {
    try {
      String userId = FirebaseAuthProvider.authService().currentUser!.id;
      final docRef = user.doc(userId);
      final docSnap = await docRef.get();
      final currentBalance = docSnap.data()![balanceFieldName];
      final toDouble = double.parse(widget.balance);
      final newBalance = toDouble + currentBalance;
      await docRef.update({"balance": newBalance});
    } catch (_) {
      throw CouldNotUpdateInformationException();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 213, 130),
          title: const Text("Cridet Card"),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumber(),
                      ],
                      controller: cardNumber,
                      decoration: InputDecoration(
                        labelText: "Card Number",
                        border: InputBorder.none,
                        floatingLabelStyle:
                            const TextStyle(color: Colors.green, fontSize: 18),
                        contentPadding: const EdgeInsets.all(30),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a card number";
                        }
                        if (value.length != 22) {
                          return "Enter a valid card number";
                        }
                        if (!(value.startsWith('4') || value.startsWith('5'))) {
                          return "Invalid card type";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      controller: cardName,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: InputBorder.none,
                        floatingLabelStyle:
                            const TextStyle(color: Colors.green, fontSize: 18),
                        contentPadding: const EdgeInsets.all(30),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "You did not enter your first name";
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            controller: cvv,
                            decoration: InputDecoration(
                              labelText: "CVV",
                              hintText: "Enter the 3 digit number",
                              border: InputBorder.none,
                              floatingLabelStyle: const TextStyle(
                                  color: Colors.green, fontSize: 18),
                              contentPadding: const EdgeInsets.all(30),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 13, 213, 130),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 13, 213, 130),
                                  width: 3,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 13, 213, 130),
                                  width: 3,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter enter a CVV";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardExpiry(),
                            ],
                            controller: expiryDate,
                            decoration: InputDecoration(
                              labelText: "Expiry date",
                              hintText: "MM/YY",
                              border: InputBorder.none,
                              floatingLabelStyle: const TextStyle(
                                  color: Colors.green, fontSize: 18),
                              contentPadding: const EdgeInsets.all(30),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 13, 213, 130),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 13, 213, 130),
                                  width: 3,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 13, 213, 130),
                                  width: 3,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter an Expiry Date";
                              }

                              List<String> parts = value.split('/');
                              if (parts.length != 2) {
                                return "Enter a valid Expiry Date";
                              }

                              int? month = int.tryParse(parts[0]);
                              int? year = int.tryParse(parts[1]);

                              if (month == null || year == null) {
                                return "Enter a valid Expiry Date";
                              }

                              if (month > 12 && year < 23) {
                                return "Enter the Expiry Date correctly";
                              }
                              if (month > 12) {
                                return "Enter the month correctly";
                              }
                              if (year < 23) {
                                return "Enter the year correctly";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 13, 213, 130)),
                              child: const Center(
                                  child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              if (formKey.currentState!.validate()) {
                                toNext();
                                showSuccessDialog(
                                    context, 'balance successefully added');
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    bottomRoute, (route) => false);
                              }
                            });
                          },
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 13, 213, 130)),
                              child: const Center(
                                  child: Text(
                                "Confirm Payment",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}

class CardNumber extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;
      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  ");
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}

class CardExpiry extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (var i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var index = i + 1;
      if (index % 2 == 0 && index != newText.length) {
        buffer.write("/");
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}
