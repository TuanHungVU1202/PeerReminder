import 'package:flutter/material.dart';

abstract class IAuthService {
  bool fetchCredentials(String username, String password);

  bool checkUserRepeat(username);

  void insertCredentials(username, password);

  bool isPasswordCompliant(String password, [int minLength = 6]);
}
