import 'package:flutter/material.dart';

class Contact {
  Contact(this.name, this.phone, this.email);
  final String name, phone, email;

  @override
  String toString() => name;
}