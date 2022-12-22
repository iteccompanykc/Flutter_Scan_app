class LoggedInUser {
  final String email;
  final String fname;
  final String lname;
  final String regdate;
  final int role;
  final int userId;
  final int identification;

  LoggedInUser({
    required this.email,
    required this.fname,
    required this.lname,
    required this.regdate,
    required this.role,
    required this.userId,
    required this.identification,
  });
}
