import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  bool _isInitializing = true;
  String _loadingText = 'Initializing...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
    _hideSystemUI();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _animationController.repeat(reverse: true);
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Load saved game progress
      await _updateProgress(0.2, 'Loading game progress...');
      await _loadGameProgress();

      // Step 2: Check level unlock status
      await _updateProgress(0.4, 'Checking level status...');
      await _checkLevelUnlockStatus();

      // Step 3: Prepare grid layouts
      await _updateProgress(0.6, 'Preparing game layouts...');
      await _prepareGridLayouts();

      // Step 4: Initialize animation controllers
      await _updateProgress(0.8, 'Initializing animations...');
      await _initializeAnimationControllers();

      // Step 5: Final setup
      await _updateProgress(1.0, 'Ready to play!');
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitializing = false;
      });

      // Navigate after a brief delay
      await Future.delayed(const Duration(milliseconds: 800));
      _navigateToNextScreen();
    } catch (e) {
      // Handle corrupted save data or other errors
      await _handleInitializationError();
    }
  }

  Future<void> _updateProgress(double progress, String text) async {
    setState(() {
      _progress = progress;
      _loadingText = text;
    });
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _loadGameProgress() async {
    // Simulate loading saved game progress
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _checkLevelUnlockStatus() async {
    // Simulate checking level unlock status
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _prepareGridLayouts() async {
    // Simulate preparing grid layouts
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _initializeAnimationControllers() async {
    // Simulate initializing Flutter animation controllers
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _handleInitializationError() async {
    setState(() {
      _loadingText = 'Preparing fresh start...';
      _progress = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isInitializing = false;
    });
  }

  void _navigateToNextScreen() {
    _restoreSystemUI();

    // Navigation logic based on user state
    // For demo purposes, we'll navigate to game tutorial
    // In real implementation, this would check user progress
    Navigator.pushReplacementNamed(context, '/game-tutorial');
  }

  @override
  void dispose() {
    _animationController.dispose();
    _restoreSystemUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.surface,
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section with animation
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Transform.scale(
                          scale: _pulseAnimation.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Loading section
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Loading indicator
                      Container(
                        width: 60.w,
                        height: 0.5.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 60.w * _progress,
                          height: 0.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Loading text
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _loadingText,
                          key: ValueKey(_loadingText),
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App icon/symbol
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '10',
                style: AppTheme.gameNumberStyle(isLight: true).copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // App name
          Text(
            'Number Puzzle',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            'Master',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
