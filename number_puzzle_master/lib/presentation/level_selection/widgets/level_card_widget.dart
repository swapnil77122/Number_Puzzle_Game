import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LevelCardWidget extends StatelessWidget {
  final Map<String, dynamic> levelData;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const LevelCardWidget({
    Key? key,
    required this.levelData,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLocked = levelData['isLocked'] as bool;
    final String difficulty = levelData['difficulty'] as String;
    final int stars = levelData['stars'] as int;
    final String? bestTime = levelData['bestTime'] as String?;
    final int levelNumber = levelData['levelNumber'] as int;

    Color cardColor = _getCardColor(difficulty, isLocked);
    Color textColor = isLocked
        ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
            .withValues(alpha: 0.5)
        : AppTheme.lightTheme.colorScheme.onSurface;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      onLongPress: isLocked || stars == 0 ? null : onLongPress,
      child: AnimatedContainer(
        duration: AppTheme.normalAnimation,
        height: 20.h,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: AppTheme.mediumRadius,
          boxShadow: isLocked ? [] : AppTheme.lightElevation,
          border: isLocked
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Stack(
          children: [
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    borderRadius: AppTheme.mediumRadius,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Level $levelNumber',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isLocked)
                        CustomIconWidget(
                          iconName: 'lock',
                          color: AppTheme
                              .lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5),
                          size: 5.w,
                        ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(difficulty)
                          .withValues(alpha: 0.2),
                      borderRadius: AppTheme.smallRadius,
                    ),
                    child: Text(
                      difficulty,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getDifficultyColor(difficulty),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (!isLocked) ...[
                    Row(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 1.w),
                          child: CustomIconWidget(
                            iconName: index < stars ? 'star' : 'star_border',
                            color: index < stars
                                ? Colors.amber
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.3),
                            size: 4.w,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 1.h),
                    if (bestTime != null)
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'timer',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 3.5.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            bestTime,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColor(String difficulty, bool isLocked) {
    if (isLocked) {
      return AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5);
    }

    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green.withValues(alpha: 0.1);
      case 'medium':
        return Colors.orange.withValues(alpha: 0.1);
      case 'hard':
        return Colors.red.withValues(alpha: 0.1);
      default:
        return AppTheme.lightTheme.colorScheme.surface;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
