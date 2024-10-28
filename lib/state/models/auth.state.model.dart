class AuthStateModel {
  bool? isAuthenticated;
  String? signedInUser;
  String? error;
  AuthStateModel({
    this.isAuthenticated,
    this.signedInUser,
    this.error,
  });
}
