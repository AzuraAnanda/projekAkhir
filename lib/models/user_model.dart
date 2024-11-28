import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String email; // Tambahkan field untuk email

  UserModel({
    required this.username,
    required this.password,
    required this.email, // Tambahkan parameter email
  });

  get photoPath => null;
}
