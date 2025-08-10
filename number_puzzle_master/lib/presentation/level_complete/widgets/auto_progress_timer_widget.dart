import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AutoProgressTimerWidget extends StatefulWidget {
  final VoidCallback onTimerComplete;
  final bool isEnabled;
  final int durationSeconds;

  const AutoProgressTimerWidget({
    super.key,
    required this.onTimerComplete,
    this.isEnabled = true,
    this.durationSeconds = 5,
  });

  @override
  State<AutoProgressTimerWidget> createState() =>
      _AutoProgressTimerWidgetState();
}

class _AutoProgressTimerWidgetState extends State<AutoProgressTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  Timer? _timer;
  int _remainingSeconds = 5;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;

    _animationController = AnimationController(
      duration: Duration(seconds: widget.durationSeconds),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    if (widget.isEnabled) {
      _startTimer();
    }
  }

  void _startTimer() {
    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        if (_isActive && widget.isEnabled) {
          widget.onTimerComplete();
        }
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isActive = false;
    });
    _timer?.cancel();
    _animationController.stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _pauseTimer,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        margin: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: _isActive ? 'timer' : 'pause_circle',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _isActive
                          ? 'Auto-advancing in $_remainingSeconds seconds'
                          : 'Auto-advance paused',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (_isActive)
                  Text(
                    '$_remainingSeconds',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            if (_isActive) ...[
              SizedBox(height: 2.h),

              // Progress Bar
              Container(
                width: double.infinity,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(0.25.h),
                ),
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(0.25.h),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 1.h),
            Text(
              _isActive
                  ? 'Tap to pause auto-advance'
                  : 'Tap any button to continue manually',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
