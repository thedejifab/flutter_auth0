import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import '../operations/models.dart';
import '../screens/profile.dart';
import '../utils/auth_utils.dart';
import '../utils/url_utils.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  String loginError;
  bool isLaunched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: isLaunched == true
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          isLaunched = true;
                        });
                        launchURL(context, url: getAuthorizationUrl());
                        getReceivedURL();
                      },
                      child: Text("Click to Login"),
                    ),
                    Text(loginError ?? ""),
                  ],
                ),
        ),
      ),
    );
  }

  StreamSubscription _sub;
  void getReceivedURL() async {
    String receivedLink;

    try {
      _sub = getLinksStream().listen(
        (String link) {
          receivedLink = link;

          if (receivedLink.startsWith(REDIRECT_URI)) {
            AuthModel authDetails = parseUrlToValue(receivedLink);
            if (!authDetails.isAuthenticated) {
              setState(() {
                isLaunched = false;
                loginError = authDetails.authCode;
              });
            } else {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return Profile(
                  isAuthCode: true,
                  code: authDetails.authCode,
                );
              })).catchError((err) {});

              isLaunched = null;
            }
          }
        },
      );
    } catch (err) {}
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
