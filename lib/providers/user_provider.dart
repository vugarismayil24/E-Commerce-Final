import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  final String name;
  final double totalSpent;
  final bool hasMadePayment;

  User({required this.name, required this.totalSpent, required this.hasMadePayment});
}

final userProvider = Provider<User>((ref) {
 
  return User(name: 'John Doe', totalSpent: 400, hasMadePayment: false); 
});
