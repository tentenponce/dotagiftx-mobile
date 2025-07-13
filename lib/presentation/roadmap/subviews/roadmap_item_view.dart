import 'dart:async';

import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/viewmodels/roadmap_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RoadmapItemView extends StatelessWidget {
  final RoadmapModel item;
  final bool isLast;

  const RoadmapItemView({required this.item, required this.isLast, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator
              Column(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color:
                          item.isCompleted
                              ? AppColors.primary
                              : item.isActive
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.darkGrey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            item.isCompleted || item.isActive
                                ? AppColors.primary
                                : AppColors.grey.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      item.isCompleted ? Icons.check : getIcon(item.id),
                      color:
                          item.isCompleted
                              ? Colors.white
                              : item.isActive
                              ? AppColors.primary
                              : AppColors.grey,
                      size: 24.sp,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.w,
                        margin: EdgeInsets.only(top: 8.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.6),
                              AppColors.grey.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16.w),

              // Content
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color:
                          item.isActive
                              ? AppColors.primary.withValues(alpha: 0.5)
                              : AppColors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (item.isActive)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                I18n.of(context).roadmapItemViewInProgress,
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (item.isCompleted)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.rare.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                I18n.of(context).roadmapItemViewCompleted,
                                style: GoogleFonts.inter(
                                  color: AppColors.rare,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        item.description,
                        style: GoogleFonts.inter(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Voting section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => _showFeedback(context, item.id),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color:
                                      item.isVoted ?? false
                                          ? AppColors.primary
                                          : AppColors.grey.withValues(
                                            alpha: 0.3,
                                          ),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.thumb_up,
                                color:
                                    item.isVoted ?? false
                                        ? AppColors.primary
                                        : AppColors.grey,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) SizedBox(height: 16.h),
      ],
    );
  }

  IconData getIcon(String id) {
    switch (id) {
      case 'initial_login':
        return Icons.login;
      case 'notification':
        return Icons.notifications_active;
      case 'in_app_messaging':
        return Icons.messenger_outline;
      case 'listings_and_orders':
        return Icons.add_business;
      default:
        return Icons.question_mark;
    }
  }

  void _showFeedback(BuildContext context, String featureId) {
    unawaited(context.read<RoadmapCubit>().vote(featureId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          I18n.of(context).roadmapItemViewSuccessVote,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
