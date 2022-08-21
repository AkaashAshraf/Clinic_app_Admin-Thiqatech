import 'package:flutter/material.dart';

class DatePicker {

  static Future<String> datePicker(BuildContext context) async {
    DateTime _selectedDate = DateTime.now();
    String date = "";
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate, // Refer step 1
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      print(picked.day);

      date = "${picked.month}-${picked.day}-${picked.year}";
    }

    return date;
  }
}