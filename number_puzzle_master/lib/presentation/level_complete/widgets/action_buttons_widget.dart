import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onNextLevel;
  final VoidCallback onReplayLevel;
  final VoidCallback onLevelSelection;
  final VoidCallback onShareAchievement;
  final bool isNextLevelAvailable;
  final bool isLastLevel;

  const ActionButtonsWidget({
    super.key,
    required this.onNextLevel,
    required this.onReplayLevel,
    required this.onLevelSelection,
    required this.onShareAchievement,
    required this.isNextLevelAvailable,
    required this.isLastLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Action Button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: isLastLevel
                ? onLevelSelection
                : (isNextLevelAvailable ? onNextLevel : null),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              elevation: 2,
              shadowColor: AppTheme.lightTheme.colorScheme.shadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              disabledForegroundColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastLevel
                      ? 'All Levels Complete!'
                      : (isNextLevelAvailable ? 'Next Level' : 'Level Locked'),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: isLastLevel || isNextLevelAvailable
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isLastLevel && isNextLevelAvailable) ...[
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 5.w,
                  ),
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Secondary Action Buttons Row
        Row(
          children: [
            // Replay Level Button
            Expanded(
              child: SizedBox(
                height: 5.h,
                child: OutlinedButton(
                  onPressed: onReplayLevel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'replay',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Replay',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Level Selection Button
            Expanded(
              child: SizedBox(
                height: 5.h,
                child: OutlinedButton(
                  onPressed: onLevelSelection,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.lightTheme.colorScheme.secondary,
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'grid_view',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Levels',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Share Achievement Button
        SizedBox(
          width: double.infinity,
          height: 5.h,
          child: TextButton(
            onPressed: onShareAchievement,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Share Achievement',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
