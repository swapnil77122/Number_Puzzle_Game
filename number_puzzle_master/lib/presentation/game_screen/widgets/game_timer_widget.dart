import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final VoidCallback onPause;

  const GameTimerWidget({
    Key? key,
    required this.remainingSeconds,
    required this.onPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Level 1',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: _getTimerColor(),
              borderRadius: AppTheme.mediumRadius,
            ),
            child: Text(
              timeString,
              style: AppTheme.gameTimerStyle(isLight: true).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: onPause,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: AppTheme.smallRadius,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'pause',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTimerColor() {
    if (remainingSeconds > 60) {
      return AppTheme.lightTheme.colorScheme.primary; // Green
    } else if (remainingSeconds > 30) {
      return Colors.orange; // Yellow/Orange
    } else {
      return AppTheme.lightTheme.colorScheme.error; // Red
    }
  }
}
