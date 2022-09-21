class Users {
  String? username;
  String? email;
  int? balance;

  Users({required this.username, required this.email, required this.balance});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "username": username,
      "email": email,
      "balance": balance
    };
    return map;
  }

  Users.fromMap(Map<String, dynamic> map) {
    username = map['username'];
    email = map['email'];
    balance = map['balance'];
  }
}
