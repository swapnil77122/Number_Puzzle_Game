import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/auto_retry_widget.dart';
import './widgets/game_stats_widget.dart';
import './widgets/grid_preview_widget.dart';
import './widgets/helpful_tips_widget.dart';

class GameOver extends StatefulWidget {
  const GameOver({Key? key}) : super(key: key);

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  int _attemptCount = 0;
  bool _showAutoRetry = false;

  // Mock game data
  final List<Map<String, dynamic>> mockGameData = [
    {
      "completionPercentage": 78,
      "successfulMatches": 12,
      "averageCompletion": 65,
      "gridData": [
        [3, 7, 2, 8, 1],
        [9, null, 4, 6, null],
        [5, 8, null, 2, 7],
        [null, 1, 9, null, 4]
      ],
      "matchedCells": [
        [true, true, true, false, false],
        [false, false, true, true, false],
        [true, false, false, true, true],
        [false, false, false, false, false]
      ]
    }
  ];

  final List<String> helpfulTips = [
    "Look for easy matches first - identical numbers are often easier to spot than sums of 10.",
    "Use Add Row strategically when you're close to completing a level but need more options.",
    "Focus on sums of 10: pairs like 1+9, 2+8, 3+7, 4+6, and 5+5 are your best friends.",
    "Scan the grid systematically - start from top-left and work your way across each row.",
    "Don't rush! Take time to analyze the grid before making your first move.",
    "Remember that matched cells stay visible but fade - use them as reference points.",
    "Practice makes perfect - each attempt teaches you new pattern recognition skills."
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _triggerHapticFeedback();

    // Show auto-retry after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showAutoRetry = true;
        });
      }
    });
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  void _triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  String _getRandomTip() {
    final random = DateTime.now().millisecondsSinceEpoch % helpfulTips.length;
    return helpfulTips[random];
  }

  void _handleTryAgain() {
    HapticFeedback.selectionClick();
    setState(() {
      _attemptCount++;
    });
    Navigator.pushReplacementNamed(context, '/game-screen');
  }

  void _handleChooseDifferentLevel() {
    HapticFeedback.selectionClick();
    Navigator.pushReplacementNamed(context, '/level-selection');
  }

  void _handleViewSolution() {
    HapticFeedback.selectionClick();
    // Show solution implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Solution view coming soon!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleAutoRetry() {
    HapticFeedback.lightImpact();
    _handleTryAgain();
  }

  void _handleBackPress() {
    Navigator.pushReplacementNamed(context, '/level-selection');
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameData = mockGameData.first;

    return Scaffold(
      backgroundColor:
          AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
      body: Stack(
        children: [
          // Semi-transparent overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.3),
          ),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: Container(
                    width: 90.w,
                    constraints: BoxConstraints(
                      maxHeight: 85.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(6.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header section
                          _buildHeader(),

                          // Time indicator
                          _buildTimeIndicator(),

                          // Encouraging message
                          _buildEncouragingMessage(),

                          // Grid preview
                          GridPreviewWidget(
                            gridData: (gameData["gridData"] as List)
                                .map((row) => (row as List).cast<int?>())
                                .toList(),
                            matchedCells: (gameData["matchedCells"] as List)
                                .map((row) => (row as List).cast<bool>())
                                .toList(),
                          ),

                          // Game statistics
                          GameStatsWidget(
                            completionPercentage:
                                gameData["completionPercentage"] as int,
                            successfulMatches:
                                gameData["successfulMatches"] as int,
                            averageCompletion:
                                gameData["averageCompletion"] as int,
                          ),

                          // Helpful tips
                          HelpfulTipsWidget(
                            randomTip: _getRandomTip(),
                          ),

                          // Action buttons
                          ActionButtonsWidget(
                            onTryAgain: _handleTryAgain,
                            onChooseDifferentLevel: _handleChooseDifferentLevel,
                            onViewSolution:
                                _attemptCount >= 3 ? _handleViewSolution : null,
                            showViewSolution: _attemptCount >= 3,
                          ),

                          // Auto-retry widget
                          AutoRetryWidget(
                            onAutoRetry: _handleAutoRetry,
                            showAutoRetry: _showAutoRetry,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 8.h,
            left: 4.w,
            child: GestureDetector(
              onTap: _handleBackPress,
              child: Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'access_time',
          color: AppTheme.errorLight,
          size: 48,
        ),
        SizedBox(height: 2.h),
        Text(
          'Time\'s Up!',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.errorLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.errorLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'timer',
            color: AppTheme.errorLight,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            '2:00',
            style: AppTheme.gameTimerStyle(isLight: true).copyWith(
              color: AppTheme.errorLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncouragingMessage() {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Text(
        'Almost there! Try again?',
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
