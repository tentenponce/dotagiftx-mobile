import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_elevated_button.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_text_field.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/subviews/roadmap_item_view.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/viewmodels/roadmap_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoadmapView extends BasePageStatelessWidget
    with ViewCubitMixin<RoadmapCubit> {
  const RoadmapView({super.key}) : super(pageName: PageName.roadmap);

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          I18n.of(context).roadmapViewTitle,
          style: AppTextStyles.defaultTextStyle(
            context,
          ).copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
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
                  color: Theme.of(context).colorScheme.surfaceContainer,
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
                      style: AppTextStyles.defaultTextStyle(context).copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      I18n.of(context).roadmapViewDescription,
                      style: AppTextStyles.defaultTextStyle(context).copyWith(
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
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  I18n.of(context).roadmapViewSuggestion,
                  maxLines: 2,
                  style: AppTextStyles.defaultTextStyle(
                    context,
                  ).copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            I18n.of(context).roadmapViewSuggestionDescription,
            style: AppTextStyles.defaultTextStyle(context).copyWith(
              color: AppColors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Text Field
          AppTextField(
            controller: _suggestionController,
            maxLines: 4,
            hintText: I18n.of(context).roadmapViewSuggestionHint,
          ),
          const SizedBox(height: 16),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: AppElevatedButton(
              onPressed: () {
                if (_suggestionController.text.trim().isNotEmpty) {
                  _submitSuggestion();
                }
              },
              width: double.infinity,
              child: Text(
                I18n.of(context).roadmapViewSubmitSuggestionButton,
                style: AppTextStyles.defaultTextStyle(context).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
          style: AppTextStyles.defaultTextStyle(context).copyWith(fontSize: 14),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Clear the text field
    _suggestionController.clear();
  }
}
