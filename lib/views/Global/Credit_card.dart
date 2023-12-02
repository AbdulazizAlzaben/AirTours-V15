import 'package:AirTours/utilities/show_balance.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:AirTours/views/Global/global_var.dart';
import 'package:AirTours/views/Global/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/pages_route.dart';
import '../../services/cloud/cloud_booking.dart';
import '../../services/cloud/firestore_booking.dart';
import '../../services/cloud/firestore_ticket.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/show_error.dart';
import 'flight_class_for_search.dart';

class Creditcard extends StatefulWidget {
  final String id1;
  final String paymentFor;
  final String id2;
  final String flightClass;
  final List<Ticket> tickets;
  const Creditcard(
      {super.key,
      required this.id1,
      required this.id2,
      required this.flightClass,
      required this.tickets,
      required this.paymentFor});

  @override
  State<Creditcard> createState() => _CreditcardState();
}

class _CreditcardState extends State<Creditcard> {
  final user = FirebaseFirestore.instance.collection('user');
  final formKey = GlobalKey<FormState>();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardName = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  late final TicketFirestore _ticketService;
  late final BookingFirestore _bookingService;
  CloudBooking? booking;
  late double price;
  late double balance;
  bool notInitialized = true;

  @override
  void initState() {
    super.initState();
    _bookingService = BookingFirestore();
    _ticketService = TicketFirestore();
    price = retrieveTotBookingsPrice();
  }

  Future<String> createBooking(double totalPrice) async {
    final bookingUserId = FirebaseAuthProvider.authService().currentUser!.id;
    DateTime timeNow = DateTime.now();
    if (widget.id2 == 'none') {
      booking = await _bookingService.createNewBooking(
          bookingClass: widget.flightClass,
          bookingPrice: totalPrice,
          departureFlight: widget.id1,
          returnFlight: 'none',
          numOfSeats: count,
          bookingUserId: bookingUserId,
          bookingTime: timeNow);
      final bookingRef = booking!.documentId;
      return bookingRef;
    } else {
      booking = await _bookingService.createNewBooking(
          bookingClass: widget.flightClass,
          bookingPrice: totalPrice,
          departureFlight: widget.id1,
          returnFlight: widget.id2,
          numOfSeats: count,
          bookingUserId: bookingUserId,
          bookingTime: timeNow);
      final bookingRef = booking!.documentId;
      return bookingRef;
    }
  }

  void toNext(List<Ticket> alltickets) async {
    final tmp = await createBooking(retrieveTotBookingsPrice());

    alltickets.forEach((ticket) async {
      await _ticketService.createNewTicket(
          firstName: ticket.firstName,
          middleName: ticket.middleName,
          checkInStatus: ticket.checkInStatus,
          bagQuantity: ticket.bagQuantity,
          mealType: ticket.mealType,
          lastName: ticket.lastName,
          ticketPrice: ticket.ticketPrice,
          bookingReference: tmp,
          ticketUserId: '1',
          birthDate: ticket.birthDate,
          flightReference: ticket.flightReference,
          ticketClass: widget.flightClass);
    });
  }

  double retrieveTotBookingsPrice() {
    double totBookingPrice = 0;
    for (final x in widget.tickets) {
      totBookingPrice = totBookingPrice + x.ticketPrice;
    }
    return totBookingPrice;
  }

  Future<double> showBalance() async {
    if (notInitialized) {
      balance = await showUserBalance();
      notInitialized = false;
    }
    return balance;
  }

  Future<void> discountBookingPrice() async {
    if (price <= balance) {
      if (price == 0.0) {
        await showErrorDialog(
            context, "Can't Discount More, Your Booking Price is already 0");
      } else {
        balance = balance - price;
        price = 0.0;
      }
    } else {
      if (balance == 0.0) {
        await showErrorDialog(context, 'No Balance Available!');
      } else {
        price = price - balance;
        balance = 0.0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 213, 130),
          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Booking Price: $price',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FutureBuilder<double>(
                    future: showBalance(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Text(
                          "Your Balance: ${snapshot.data!}",
                          style: const TextStyle(fontSize: 16),
                        );
                      } else {
                        return const Text('No Data Available');
                      }
                    },
                  )
                ],
              ),
            ),
          ],
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
                              if (year < 24) {
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
                                color: const Color.fromARGB(255, 13, 213, 130),
                              ),
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
                            bool isSuccessful = false;
                            setState(() {
                              if (formKey.currentState!.validate()) {
                                isSuccessful = true;
                              }
                            });
                            if (isSuccessful) {
                              toNext(widget.tickets);
                              String userId = FirebaseAuthProvider.authService()
                                  .currentUser!
                                  .id;
                              final docR = user.doc(userId);
                              await docR.update({'balance': balance});
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  bottomRoute, (route) => false);
                              await showSuccessDialog(
                                  context, "Flight is booked");

                              List<flightInformation> flightNameTestCopy =
                                  List.from(forSave);
                              flightNameTest = flightNameTestCopy;
                              cityNameDel = null;
                              cityNameDel2 = null;
                              indexToUpdate = null;
                              indexToUpdate2 = null;
                            }
                          },
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 13, 213, 130),
                              ),
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
                  GestureDetector(
                    onTap: () async {
                      await discountBookingPrice();
                      setState(() {});
                    },
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 13, 213, 130),
                        ),
                        child: const Center(
                            child: Text(
                          "Discount Using Balance",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ))),
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
