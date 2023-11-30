import 'package:flutter/material.dart';

Widget SearchFlightFrom(String? selectedCity, int selectNum) {
  return Container(
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (selectNum == 1) const Icon(Icons.location_on_outlined),
        if (selectNum == 1)
          const SizedBox(
            width: 5,
          ),
        if (selectNum == 1)
          Text(
            selectedCity != null ? '${selectedCity}' : 'From',
          ),
        if (selectNum == 2) const Icon(Icons.my_location),
        if (selectNum == 2)
          const SizedBox(
            width: 5,
          ),
        if (selectNum == 2)
          Text(
            selectedCity != null ? '${selectedCity}' : 'To',
          ),
      ],
    ),
  );
}

Widget searchButton() {
  return Container(
    margin: const EdgeInsets.all(2),
    padding: const EdgeInsets.all(15),
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 13, 213, 130)),
    child: const Center(
        child: Text(
      "Search",
      style: TextStyle(
        color: Colors.white,
      ),
    )), //change color to green
  );
}

Widget checkSerchValidation(
    int checkNum1, int checkNum2, String checkCity1, String checkCity2) {
  return Row(
    children: [
      if (checkNum1 == 1 || checkNum2 == 1)
        const Text(
          textAlign: TextAlign.start,
          //new line
          'Please select city', //new line
          style: TextStyle(
            fontSize: 13, //new line
            color: Colors.red, //new line
          ), //new line
        ),
    ],
  );
}
