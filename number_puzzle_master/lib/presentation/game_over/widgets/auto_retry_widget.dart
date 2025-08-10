import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AutoRetryWidget extends StatefulWidget {
  final VoidCallback onAutoRetry;
  final bool showAutoRetry;

  const AutoRetryWidget({
    Key? key,
    required this.onAutoRetry,
    required this.showAutoRetry,
  }) : super(key: key);

  @override
  State<AutoRetryWidget> createState() => _AutoRetryWidgetState();
}

class _AutoRetryWidgetState extends State<AutoRetryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  int _countdown = 10;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    if (widget.showAutoRetry) {
      _startCountdown();
    }
  }

  @override
  void didUpdateWidget(AutoRetryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showAutoRetry && !oldWidget.showAutoRetry) {
      _startCountdown();
    } else if (!widget.showAutoRetry && oldWidget.showAutoRetry) {
      _stopCountdown();
    }
  }

  void _startCountdown() {
    setState(() {
      _isActive = true;
      _countdown = 10;
    });

    _animationController.forward();

    // Update countdown every second
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isActive || !mounted) return false;

      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        widget.onAutoRetry();
        return false;
      }
      return true;
    });
  }

  void _stopCountdown() {
    setState(() {
      _isActive = false;
    });
    _animationController.stop();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAutoRetry || !_isActive) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'timer',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Auto-retry in $_countdown seconds',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.secondary,
                ),
                minHeight: 4,
              );
            },
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: _stopCountdown,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.secondary,
            ),
            child: Text(
              'Cancel Auto-retry',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
