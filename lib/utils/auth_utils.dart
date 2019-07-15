import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import '../operations/models.dart';

void launchURL(BuildContext context, {String url}) async {
  try {
    await launch(
      url,
      option: new CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: new CustomTabsAnimation.slideIn(),
        extraCustomTabs: <String>[
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

AuthModel parseUrlToValue(String receivedURL) {
  String value;
  bool isAuthenticated = false;

  Uri uri = Uri.parse(receivedURL);
  if (uri.queryParameters.keys.contains('code')) {
    value = uri.queryParameters['code'];
    isAuthenticated = true;
  } else {
    value = uri.queryParameters['error'];
  }

  return AuthModel(isAuthenticated: isAuthenticated, authCode: value);
}