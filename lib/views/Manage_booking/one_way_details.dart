// ignore_for_file: use_build_context_synchronously

import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/services_auth/firebase_auth_provider.dart';
import 'package:AirTours/utilities/show_error.dart';
import 'package:AirTours/views/Manage_booking/tickets_view.dart';
import 'package:AirTours/views/Manage_booking/upgrade_card.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services/cloud/firestore_booking.dart';
import '../../services/cloud/firestore_flight.dart';
import '../../utilities/show_feedback.dart';
import '../Global/global_var.dart';
import '../Global/ticket.dart';

class OneWayDetails extends StatefulWidget {
  final CloudBooking booking;
  final CloudFlight depFlight;

  const OneWayDetails({
    super.key,
    required this.booking,
    required this.depFlight,
  });

  @override
  State<OneWayDetails> createState() => _OneWayDetailsState();
}

class _OneWayDetailsState extends State<OneWayDetails> {
  final FirebaseCloudStorage c = FirebaseCloudStorage();
  late final BookingFirestore _bookingService;
  late final CloudFlight departFlight;
  late final CloudBooking currentBooking;
  late final FlightFirestore _flightsService;
  late String bookingType;
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    _bookingService = BookingFirestore();
    departFlight = widget.depFlight;
    currentBooking = widget.booking;
    _flightsService = FlightFirestore();
    bookingType = currentBooking.bookingClass;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 13, 213, 130),
        title: const Text('Booking Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketsView(
                          booking: widget.booking, flight: widget.depFlight),
                    ));
              },
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Destination Flight",
                                style: TextStyle(fontSize: 22),
                              ),
                              // Text(
                              //   date1(departFlight.depDate),
                              //   style: const TextStyle(
                              //     fontSize: 17,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                            ],
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.grey,
                            width: double.infinity,
                            //child: SizedBox.expand(),
                          ),
                          Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("Departure: ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        )),
                                    Text(
                                      date1(departFlight.depDate),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                // const Text("-"),
                                Row(
                                  children: [
                                    const Text("Arrival: ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        )),
                                    Text(
                                      date1(departFlight.arrDate),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.depFlight.fromCity,
                                      style: const TextStyle(fontSize: 19),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      height: 20,
                                      child:
                                          Image.asset('images/flight-Icon.png'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.depFlight.toCity,
                                      style: const TextStyle(fontSize: 19),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        '${shortCutFlightName[widget.depFlight.fromCity]} - '),
                                    Text(
                                        '${shortCutFlightName[widget.depFlight.toCity]}')
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _flightsService
                                              .formatTime(departFlight.depTime),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                          child: Text("-"),
                                        ),
                                        Text(
                                          _flightsService
                                              .formatTime(departFlight.arrTime),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Column(
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //         "Passenger: ${widget.booking.numOfSeats}")
                                    //   ],
                                    // )
                                  ],
                                )
                              ],
                            )
                          ]),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      )))),
          const SizedBox(height: 16.0),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  Visibility(
                    visible: bookingType != 'Business',
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (await _flightsService.didFly(
                              departureFlightId: departFlight.documentId)) {
                            bool? nextPage = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UpgradeCard()),
                            );
                            if (nextPage == true) {
                              bool result = await _bookingService.upgradeOneWay(
                                bookingId: currentBooking.documentId,
                                departureFlightId: departFlight.documentId,
                                numOfPas: currentBooking.numOfSeats,
                              );

                              if (result == true) {
                                setState(() {
                                  showSuccessDialog(context,
                                      'Booking successfully upgraded.');
                                  bookingType = 'Business';
                                });
                              } else {
                                showErrorDialog(
                                    context, 'Failed to upgrade booking.');
                              }
                            } else {
                              showErrorDialog(context, 'Payment Failed');
                            }
                          } else {
                            showErrorDialog(context,
                                'Cannot Upgrade Booking, Upgradation Deadline Passed');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 13, 213, 130),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Upgrade Booking',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final canceledBookingPrice = await c
                            .canceledBookingPrice(currentBooking.documentId);
                        bool result = await _bookingService.deleteBooking(
                            bookingId: currentBooking.documentId,
                            flightId1: departFlight.documentId,
                            flightId2: 'none',
                            flightClass: currentBooking.bookingClass,
                            numOfPas: currentBooking.numOfSeats);
                        if (result == true) {
                          c.retrievePreviousBalance(
                              FirebaseAuthProvider.authService()
                                  .currentUser!
                                  .id,
                              canceledBookingPrice);
                          await showSuccessDialog(
                              context, 'Booking successfully deleted.');
                          Navigator.pop(context);
                        } else {
                          showErrorDialog(context,
                              "Cannot Cancel Booking, Cancellation Deadline Passed");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Cancel Booking',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
