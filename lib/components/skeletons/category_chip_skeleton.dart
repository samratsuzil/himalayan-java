import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryChipSkeleton extends StatelessWidget {
  const CategoryChipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        height: 36,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
