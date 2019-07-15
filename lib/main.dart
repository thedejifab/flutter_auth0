import './screens/login.dart';
import './screens/profile.dart';
import './utils/persistence.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  bool isLoggedIn = false;
  String refreshToken;

  @override
  void initState() {
    initAction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return refreshToken == null
        ? Login()
        : Profile(
            isAuthCode: false,
            code: refreshToken,
          );
  }

  void initAction() async {
    final receivedRefreshToken = await getRefreshToken();
    if (receivedRefreshToken != null && receivedRefreshToken.isNotEmpty) {
      setState(() {
        refreshToken = receivedRefreshToken;
      });
    }
  }
}