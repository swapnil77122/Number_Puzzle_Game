import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TutorialOverlayWidget extends StatelessWidget {
  final Widget child;
  final String? arrowText;
  final Offset? arrowPosition;
  final bool showArrow;

  const TutorialOverlayWidget({
    super.key,
    required this.child,
    this.arrowText,
    this.arrowPosition,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withValues(alpha: 0.7),
        ),

        // Main content
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: child,
          ),
        ),

        // Arrow and text if needed
        if (showArrow && arrowPosition != null && arrowText != null)
          Positioned(
            left: arrowPosition!.dx,
            top: arrowPosition!.dy,
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 8.w,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    arrowText!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
