import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          item.isCompleted
                              ? Theme.of(context).colorScheme.primary
                              : item.isActive
                              ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.2)
                              : Theme.of(context).colorScheme.surfaceContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            item.isCompleted || item.isActive
                                ? Theme.of(context).colorScheme.primary
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
                              ? Theme.of(context).colorScheme.primary
                              : AppColors.grey,
                      size: 24,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.6),
                              AppColors.grey.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          item.isActive
                              ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.5)
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
                              style: AppTextStyles.defaultTextStyle(
                                context,
                              ).copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (item.isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                I18n.of(context).roadmapItemViewInProgress,
                                style: AppTextStyles.defaultTextStyle(
                                  context,
                                ).copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (item.isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.rare.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                I18n.of(context).roadmapItemViewCompleted,
                                style: AppTextStyles.defaultTextStyle(
                                  context,
                                ).copyWith(
                                  color: AppColors.rare,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: AppTextStyles.defaultTextStyle(context).copyWith(
                          color: AppColors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const SizedBox(height: 16),
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
}
