class User{
  String name;
  String surname;
  String? email;
  String? password;
  String? pregnancyStatus;
  String? userId;
  String? accessToken;
  String? refreshToken;

  User({required this.name,required this.surname,required this.email,required this.password,required this.pregnancyStatus,required this.userId,required this.accessToken,required this.refreshToken});
}