import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import '../screens/login.dart';
import '../operations/models.dart';
import '../operations/operations.dart';
import '../utils/auth_utils.dart';
import '../utils/url_utils.dart';

class Profile extends StatefulWidget {
  final String code;
  final bool isAuthCode;

  const Profile({
    Key key,
    @required this.code,
    @required this.isAuthCode,
  }) : super(key: key);

  @override
  ProfileState createState() {
    return new ProfileState();
  }
}

class ProfileState extends State<Profile> {
  User user;
  String accessToken;
  static const String LOGOUT_URL = 'my-flutter-app://logout-callback';

  @override
  void initState() {
    initAction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: user == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 4.0),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(user.pictureUrl),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Text('Fullname: ${user.name}'),
                  SizedBox(height: 24.0),
                  Text('Nickname: ${user.nickname}'),
                  SizedBox(height: 48.0),
                  RaisedButton(
                    onPressed: () {
                      launchURL(context,
                          url:
                              "https://$DOMAIN/v2/logout?returnTo=${Uri.encodeFull(LOGOUT_URL)}");
                      logoutAction();
                      getReceivedURL();
                    },
                    child: Text("Click to Logout"),
                  ),
                ],
              ),
      ),
    );
  }

  void initAction() async {
    if (widget.isAuthCode == true) {
      final accessToken = await getNewTokens(widget.code);
      final receivedUser = await getUserDetails(accessToken);
      setState(() {
        user = receivedUser;
      });
    } else {
      final accessToken = await getAccessFromRefreshTokens(widget.code);
      final receivedUser = await getUserDetails(accessToken);
      setState(() {
        user = receivedUser;
      });
    }
  }

  StreamSubscription _sub;
  void getReceivedURL() async {
    String receivedLink;

    try {
      _sub = getLinksStream().listen(
        (String link) {
          receivedLink = link;
          if (receivedLink.startsWith(LOGOUT_URL)) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return Login();
            }));
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
