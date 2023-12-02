import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/services/cloud/firebase_cloud_storage.dart';
import 'package:AirTours/utilities/show_balance.dart';
import 'package:AirTours/utilities/show_error.dart';
import 'package:flutter/material.dart';

import '../../services_auth/firebase_auth_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(addBalanceRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.wallet,
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Wallet Recharge",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FutureBuilder<double>(
                            future: showUserBalance(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text("${snapshot.data} SAR  ",
                                    style: const TextStyle(
                                        fontSize: 15.0, color: Colors.black));
                              } else {
                                return const Text(
                                  '0.0 SAR  ',
                                  style: TextStyle(fontSize: 15),
                                );
                              }
                            },
                          ),
                          const Text(
                            '>',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuthProvider.authService().logOut();
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                        loginForEmailChangesRoute, (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Change Email',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        '>',
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuthProvider.authService().logOut();
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                        loginForPasswordChangesRoute, (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.published_with_changes_sharp,
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Change Password',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        '>',
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuthProvider.authService().logOut();
                    Navigator.of(context).pushNamed(loginRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.output_rounded,
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Log Out',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final userId =
                        FirebaseAuthProvider.authService().currentUser!.id;
                    final isBooking =
                        await c.isCurrentBooking(ownerUserId: userId);
                    if (isBooking) {
                      await showErrorDialog(context,
                          "Account Can't Be Deleted, There Are Bookings In Progress!");
                    } else {
                      await FirebaseAuthProvider.authService().logOut();
                      await Navigator.of(context).pushNamedAndRemoveUntil(
                          loginForDeleteRoute, (route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      'Delete Account',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
