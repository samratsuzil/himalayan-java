import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AuthorCardSkeleton extends StatelessWidget {
  const AuthorCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: null),
    );
  }
}
