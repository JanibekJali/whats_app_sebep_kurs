class UserModel {
  final String id;
  final String userName;
  final String email;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
  });

  Map<String, dynamic> toFirebase() => {
        'id': id as String,
        'userName': userName as String,
        'email': email as String,
      };
  factory UserModel.fromFirebase(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
    );
  }
}
