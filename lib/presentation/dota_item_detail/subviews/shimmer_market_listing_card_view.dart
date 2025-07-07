import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerMarketListingCardView extends StatelessWidget {
  const ShimmerMarketListingCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Shimmer.fromColors(
          baseColor: AppColors.darkGrey,
          highlightColor: AppColors.grey.withValues(alpha: 0.5),
          child: Row(
            children: [
              // Avatar placeholder
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // User Info placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and badge row
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 60,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Date placeholder
                    Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Price placeholder
              Container(
                width: 60,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
