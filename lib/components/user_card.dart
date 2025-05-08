import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  const UserCard({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.teal[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.imageUrl),
        radius: 24,
        backgroundColor: Colors.grey[200],
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      dense: false,
      onTap: () {
        onTap?.call();
      },
    );
  }
}
