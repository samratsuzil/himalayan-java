import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      hoverColor: Colors.teal,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.imageUrl),
        radius: 24,
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text("Author ID: ${user.id}"),
      onTap: () {
        // Optional: add navigation or actions here
      },
    );
  }
}
