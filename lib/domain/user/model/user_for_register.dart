class UserForRegister {
  final String email;
  final String username;
  final String fullName;
  final String password;
  final DateTime birthDate;
  final String confirmPassword;

  UserForRegister({
    required this.email,
    required this.username,
    required this.fullName,
    required this.password,
    required this.birthDate,
    required this.confirmPassword,
  });
}