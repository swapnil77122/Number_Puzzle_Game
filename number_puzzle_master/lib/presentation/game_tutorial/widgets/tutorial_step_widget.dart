import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TutorialStepWidget extends StatelessWidget {
  final String title;
  final String description;
  final Widget? highlightWidget;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final bool showNextButton;
  final bool showSkipButton;
  final int currentStep;
  final int totalSteps;

  const TutorialStepWidget({
    super.key,
    required this.title,
    required this.description,
    this.highlightWidget,
    this.onNext,
    this.onSkip,
    this.showNextButton = true,
    this.showSkipButton = true,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: AppTheme.lightElevation,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          Row(
            children: List.generate(totalSteps, (index) {
              return Container(
                margin: EdgeInsets.only(right: 2.w),
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < currentStep
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                ),
              );
            }),
          ),
          SizedBox(height: 3.h),

          // Title
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Description
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          SizedBox(height: 3.h),

          // Highlight widget if provided
          if (highlightWidget != null) ...[
            highlightWidget!,
            SizedBox(height: 3.h),
          ],

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showSkipButton)
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Skip Tutorial',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              if (showNextButton)
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                  child: Text(
                    currentStep == totalSteps ? 'Start Playing' : 'Next',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
