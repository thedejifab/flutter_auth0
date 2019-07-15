/*Authentication model which defines whether the user has granted the application 
access or not, with a corresponding code if it is authorized.*/
class AuthModel {
  final bool isAuthenticated;
  final String authCode;

  const AuthModel({this.isAuthenticated, this.authCode});
}

// User object model
class User {
  final String pictureUrl;
  final String name;
  final String nickname;

  const User({this.pictureUrl, this.name, this.nickname});
}