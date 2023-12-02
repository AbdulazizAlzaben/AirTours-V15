import 'package:AirTours/views/Profile/balance_credit_card.dart';
import 'package:flutter/material.dart';

class AddBalance extends StatefulWidget {
  const AddBalance({super.key});

  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  late final TextEditingController _amount;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _amount = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text("Wallet Recharge"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    ), //new line(prefixIcon)
                    border: InputBorder.none,
                    labelText: 'Amount Required',
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
                        !RegExp(r'^[1-9][0-9]*(\.[0-9]+)?$').hasMatch(value)) {
                      return 'Enter Correct Amount';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () async {
                    bool isSuccessful = false;
                    setState(() {
                      if (formKey.currentState!.validate()) {
                        isSuccessful = true;
                      }
                    });
                    if (isSuccessful) {
                      final balance = _amount.text;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChargeBalance(balance: balance),
                          ));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 0, right: 0),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 13, 213, 130)),
                    child: const Center(
                        child: Text(
                      'Add Amount',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
