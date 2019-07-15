import 'dart:async';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> storeRefreshToken({@required String refreshToken}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString('refresh_token', refreshToken);
}

Future<String> getRefreshToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String refreshToken = sharedPreferences.getString('refresh_token');
  return refreshToken;
}

Future<Null> deleteRefreshToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.remove('refresh_token');
}