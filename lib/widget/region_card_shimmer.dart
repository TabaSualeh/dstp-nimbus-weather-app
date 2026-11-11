import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class RegionShimmer extends StatelessWidget {
  const RegionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 1000),
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade200,
        child: Row(
          children: List.generate(
            6,
            (index) => regionCardShimmer(),
          ),
        ),
      ),
    );
  }

  Widget regionCardShimmer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      margin: const EdgeInsets.only(left: 15, top: 14, bottom: 14),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: AppColors.sideBorderColor,
        ),
      ),
    );
  }
}
