import 'dart:io';
import 'package:flutter/material.dart';

class con {
  static String? firstName;
  static String? lastName;
  static String? phone;
  static String? email;
}

class Contact {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  File? image;

  Contact({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.image,
  });
}

class Controllers {
  static TextEditingController firstName = TextEditingController();
  static TextEditingController lastName = TextEditingController();
  static TextEditingController phoneNumber = TextEditingController();
  static TextEditingController email = TextEditingController();
}

