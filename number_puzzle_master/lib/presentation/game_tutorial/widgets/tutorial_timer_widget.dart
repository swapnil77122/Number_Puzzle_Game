import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TutorialTimerWidget extends StatefulWidget {
  final int initialSeconds;
  final bool isActive;
  final VoidCallback? onTimerComplete;

  const TutorialTimerWidget({
    super.key,
    this.initialSeconds = 120,
    this.isActive = false,
    this.onTimerComplete,
  });

  @override
  State<TutorialTimerWidget> createState() => _TutorialTimerWidgetState();
}

class _TutorialTimerWidgetState extends State<TutorialTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _remainingSeconds = 120;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (_remainingSeconds <= 30) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    if (_remainingSeconds <= 10) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (_remainingSeconds <= 30) {
      return AppTheme.warningLight;
    }
    return AppTheme.lightTheme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _remainingSeconds <= 30 ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: _getTimerColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.w),
              border: Border.all(
                color: _getTimerColor(),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'timer',
                  color: _getTimerColor(),
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  _formatTime(_remainingSeconds),
                  style: AppTheme.gameTimerStyle(isLight: true).copyWith(
                    color: _getTimerColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
