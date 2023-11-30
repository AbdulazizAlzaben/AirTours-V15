import 'package:AirTours/constants/booking_constants.dart';
import 'package:AirTours/constants/flight_constants.dart';
import 'package:AirTours/constants/ticket_constants.dart';
import 'package:AirTours/constants/user_constants.dart';
import 'package:AirTours/services/cloud/cloud_storage_exceptions.dart';
import 'package:AirTours/services/cloud/firestore_flight.dart';
import 'package:AirTours/utilities/show_balance.dart';
import 'package:AirTours/views/Global/global_var.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services_auth/firebase_auth_provider.dart';

class FirebaseCloudStorage {
  final user = FirebaseFirestore.instance.collection('user');
  final admins = FirebaseFirestore.instance.collection('admins');
  final bookings = FirebaseFirestore.instance.collection('bookings');
  final tickets = FirebaseFirestore.instance.collection('tickets');
  final flight = FirebaseFirestore.instance.collection('flights');
  final FlightFirestore flights = FlightFirestore();

  Future<bool> isCurrentBooking({required ownerUserId}) async {
    final booking =
        await bookings.where(bookingUserIdField, isEqualTo: ownerUserId).get();
    final documents = booking.docs;
    if (documents.isNotEmpty) {
      for (final document in documents) {
        final docRef = document.reference;
        final docSnap = await docRef.get();
        final returnId = docSnap.data()![returnFlightField];
        final depId = docSnap.data()![departureFlightField];

        final bool isCurrent = await flights.isCurrentFlight(depId, returnId);

        if (isCurrent) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  Future<void> deleteUser({required ownerUserId}) async {
    try {
      final userDocRef = user.doc(ownerUserId);

      final booking = await bookings
          .where(bookingUserIdField, isEqualTo: ownerUserId)
          .get();
      final documents = booking.docs;
      if (documents.isNotEmpty) {
        for (final document in documents) {
          final docRef = document.reference;
          final docSnap = await docRef.get();
          final String returnId = docSnap.data()![returnFlightField];
          final String depId = docSnap.data()![departureFlightField];

          final bool isCurrent = await flights.isCurrentFlight(depId, returnId);

          if (!isCurrent) {
            await userDocRef.delete();
            await FirebaseAuthProvider.authService().deleteAccount();
            break;
          }
        }
      } else {
        await userDocRef.delete();
        await FirebaseAuthProvider.authService().deleteAccount();
      }
    } catch (_) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<bool> isAdmin({required String email}) async {
    final admin = await admins.where('email', isEqualTo: email).get();
    return admin.docs.isNotEmpty;
  }

  Future<bool> isUser({required ownerUserId}) async {
    final docRef = user.doc(ownerUserId);
    final docSnap = await docRef.get();
    return docSnap.exists;
  }

  Future<void> updateUser(
      {required String ownerUserId, required String email}) async {
    try {
      DocumentReference docRef = user.doc(ownerUserId);
      await docRef.update({"email": email});
    } catch (_) {
      throw CouldNotUpdateInformationException();
    }
  }

  Future<void> createNewUser(
      {required String ownerUserId,
      required String email,
      required String phoneNum,
      required double balance}) async {
    try {
      DocumentReference docRef = user.doc(ownerUserId);
      await docRef
          .set({"email": email, "phoneNum": phoneNum, "balance": balance});
    } catch (_) {
      throw CouldNotCreateUserException();
    }
  }

  Future<double> canceledBookingPrice(bookingId) async {
    try {
      final docRef = bookings.doc(bookingId);

      final docSnap = await docRef.get();
      final bookingPrice = docSnap.data()![bookingPriceField];
      return bookingPrice + 0.0;
    } catch (_) {
      throw CouldNotRetrieveInformationException();
    }
  }

  Future<void> retrievePreviousBalance(ownerUserId, bookingPrice) async {
    try {
      final userDocReference = user.doc(ownerUserId);
      final currentBalance = await showUserBalance();
      final previousBalance = bookingPrice + currentBalance;
      userDocReference.update({'balance': previousBalance});
    } catch (_) {
      throw CouldNotUpdateInformationException();
    }
  }

  Future<double> upgradePrice() async {
    final doc = bookings.doc(whichBooking);
    final docSnap = await doc.get();
    final bookingClass = docSnap.data()![bookingClassField];
    final depFlight = docSnap.data()![departureFlightField];
    final doc2 = flight.doc(depFlight);
    final doc2Snap = await doc2.get();
    final busFlightPrice = doc2Snap.data()![busPriceField] + 0.0;
    if (bookingClass != 'business') {
      final ticket = await tickets
          .where(bookingReferenceField, isEqualTo: whichBooking)
          .get();
      final documents = ticket.docs;
      int counter = 0;
      double ticketsPrice = 0;
      for (final document in documents) {
        ticketsPrice += document[ticketPriceField];
        counter += 1;
      }
      final totBusPrice = busFlightPrice * counter;
      final upgradePrice = totBusPrice - ticketsPrice;
      return upgradePrice + 0.0;
    } else {
      return 0;
    }
  }

  Future<int> convertUserToAdmin(
      {required String email, required String phoneNum}) async {
    final users = await user.where('email', isEqualTo: email).get();
    final documents = users.docs;
    if (documents.isNotEmpty) {
      bool isExist = await isAdminExist(email);
      if (!isExist) {
        await admins.add({"email": email});
        return 0;
      } else {
        return 1; //admin is there
      }
    } else {
      return 2; //user not found
    }
  }

  Future<bool> isAdminExist(String email) async {
    final admin = await admins.where(emailFieldName, isEqualTo: email).get();
    final documents = admin.docs;
    return documents.isNotEmpty;
  }

  Future<bool> isDuplicateFlight(String flightId) async {
    final userId = FirebaseAuthProvider.authService().currentUser!.id;
    final booking =
        await bookings.where(bookingUserIdField, isEqualTo: userId).get();
    final documents = booking.docs;
    bool isDuplicate = false;
    if (documents.isNotEmpty) {
      for (final document in documents) {
        if (document[departureFlightField] == flightId) {
          isDuplicate = true;
        }
      }
      return isDuplicate;
    } else {
      return isDuplicate;
    }
  }

  Future<bool> isDuplicateFlight2(String flightId) async {
    final userId = FirebaseAuthProvider.authService().currentUser!.id;
    final booking =
        await bookings.where(bookingUserIdField, isEqualTo: userId).get();
    final documents = booking.docs;
    bool isDuplicate = false;
    if (documents.isNotEmpty) {
      for (final document in documents) {
        if (document[returnFlightField] == flightId) {
          isDuplicate = true;
        }
      }
      return isDuplicate;
    } else {
      return isDuplicate;
    }
  }
}
