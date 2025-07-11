import 'package:collection/collection.dart';
import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/subviews/roadmap_item_view.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/viewmodels/roadmap_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RoadmapView extends StatefulWidget {
  const RoadmapView({super.key});

  @override
  State<RoadmapView> createState() => _RoadmapViewState();
}

class _RoadmapViewState extends State<RoadmapView>
    with ViewCubitMixin<RoadmapCubit> {
  final TextEditingController _suggestionController = TextEditingController();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          I18n.of(context).roadmapViewTitle,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false, // App bar handles the top area
        bottom: true, // Ensure content respects navigation bar
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      I18n.of(context).roadmapViewUpcomingFeatures,
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      I18n.of(context).roadmapViewDescription,
                      style: GoogleFonts.inter(
                        color: AppColors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Roadmap Items
              BlocBuilder<RoadmapCubit, List<RoadmapModel>>(
                builder: (context, roadmap) {
                  return Column(
                    children:
                        roadmap.mapIndexed((index, item) {
                          final isLast = index == roadmap.length - 1;

                          return RoadmapItemView(item: item, isLast: isLast);
                        }).toList(),
                  );
                },
              ),

              SizedBox(height: 40.h),

              // User Suggestions Section
              _buildSuggestionsSection(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _suggestionController.dispose();
    super.dispose();
  }

  Widget _buildSuggestionsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  I18n.of(context).roadmapViewSuggestion,
                  maxLines: 2,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            I18n.of(context).roadmapViewSuggestionDescription,
            style: GoogleFonts.inter(
              color: AppColors.grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),

          // Text Field
          TextField(
            controller: _suggestionController,
            maxLines: 4,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: I18n.of(context).roadmapViewSuggestionHint,
              hintStyle: GoogleFonts.inter(
                color: AppColors.grey,
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: AppColors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              contentPadding: EdgeInsets.all(16.w),
            ),
          ),
          SizedBox(height: 16.h),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_suggestionController.text.trim().isNotEmpty) {
                  _submitSuggestion();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                I18n.of(context).roadmapViewSubmitSuggestionButton,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitSuggestion() {
    // Handle suggestion submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          I18n.of(context).roadmapViewSubmitSuggestionSuccess,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );

    // Clear the text field
    _suggestionController.clear();
  }
}
