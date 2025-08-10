import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MatchAnimationWidget extends StatefulWidget {
  final bool showSuccess;
  final bool showError;
  final VoidCallback? onAnimationComplete;

  const MatchAnimationWidget({
    Key? key,
    required this.showSuccess,
    required this.showError,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<MatchAnimationWidget> createState() => _MatchAnimationWidgetState();
}

class _MatchAnimationWidgetState extends State<MatchAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _successController;
  late AnimationController _errorController;
  late Animation<double> _successScale;
  late Animation<double> _errorShake;

  @override
  void initState() {
    super.initState();

    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _errorController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _successScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));

    _errorShake = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _errorController,
      curve: Curves.elasticInOut,
    ));

    _successController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _successController.reverse().then((_) {
          if (widget.onAnimationComplete != null) {
            widget.onAnimationComplete!();
          }
        });
      }
    });

    _errorController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _errorController.reverse().then((_) {
          if (widget.onAnimationComplete != null) {
            widget.onAnimationComplete!();
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(MatchAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showSuccess && !oldWidget.showSuccess) {
      _successController.forward();
    }

    if (widget.showError && !oldWidget.showError) {
      _errorController.forward();
    }
  }

  @override
  void dispose() {
    _successController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.showSuccess)
          AnimatedBuilder(
            animation: _successScale,
            builder: (context, child) {
              return Transform.scale(
                scale: _successScale.value,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              );
            },
          ),
        if (widget.showError)
          AnimatedBuilder(
            animation: _errorShake,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_errorShake.value * 10, 0),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
