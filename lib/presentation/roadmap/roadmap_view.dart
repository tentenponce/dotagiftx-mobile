import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/subviews/roadmap_item_view.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/viewmodels/roadmap_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoadmapView extends StatelessWidget with ViewCubitMixin<RoadmapCubit> {
  const RoadmapView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return _RoadmapView();
  }
}

class _RoadmapView extends StatefulWidget {
  @override
  State<_RoadmapView> createState() => _RoadmapViewState();
}

class _RoadmapViewState extends State<_RoadmapView> {
  final TextEditingController _suggestionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        surfaceTintColor: AppColors.black,
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          I18n.of(context).roadmapViewTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Suggestions Section
              _buildSuggestionsSection(),
              const SizedBox(height: 40),

              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(12),
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
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      I18n.of(context).roadmapViewDescription,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12),
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
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  I18n.of(context).roadmapViewSuggestion,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            I18n.of(context).roadmapViewSuggestionDescription,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Text Field
          TextField(
            controller: _suggestionController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: I18n.of(context).roadmapViewSuggestionHint,
              hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
              filled: true,
              fillColor: AppColors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),

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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                I18n.of(context).roadmapViewSubmitSuggestionButton,
                style: const TextStyle(
                  fontSize: 16,
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
    unawaited(
      context.read<RoadmapCubit>().submitSuggestion(_suggestionController.text),
    );

    // Handle suggestion submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          I18n.of(context).roadmapViewSubmitSuggestionSuccess,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Clear the text field
    _suggestionController.clear();
  }
}
