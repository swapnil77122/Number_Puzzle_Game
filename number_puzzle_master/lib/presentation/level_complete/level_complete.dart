import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/auto_progress_timer_widget.dart';
import './widgets/completion_celebration_widget.dart';
import './widgets/completion_stats_widget.dart';
import './widgets/progress_indicator_widget.dart';

class LevelComplete extends StatefulWidget {
  const LevelComplete({super.key});

  @override
  State<LevelComplete> createState() => _LevelCompleteState();
}

class _LevelCompleteState extends State<LevelComplete>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _cardController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _cardAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock completion data
  final Map<String, dynamic> completionData = {
    "levelNumber": 12,
    "difficultyLevel": "Medium",
    "completionTime": "1:23",
    "movesCount": 45,
    "starsEarned": 3,
    "personalBest": "1:15",
    "isNewRecord": false,
    "currentLevel": 12,
    "totalLevels": 50,
    "isNextLevelUnlocked": true,
    "isLastLevel": false,
    "overallStats": {
      "totalLevelsCompleted": 12,
      "averageTime": "1:45",
      "totalStars": 34,
      "perfectLevels": 8,
    }
  };

  bool _userInteracted = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _triggerHapticFeedback();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    _backgroundController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _cardController.forward();
  }

  void _triggerHapticFeedback() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 300), () {
      HapticFeedback.lightImpact();
    });
  }

  void _handleUserInteraction() {
    setState(() {
      _userInteracted = true;
    });
  }

  void _handleNextLevel() {
    _handleUserInteraction();
    HapticFeedback.selectionClick();

    if (completionData["isNextLevelUnlocked"] as bool) {
      Navigator.pushReplacementNamed(context, '/game-screen');
    }
  }

  void _handleReplayLevel() {
    _handleUserInteraction();
    HapticFeedback.selectionClick();
    Navigator.pushReplacementNamed(context, '/game-screen');
  }

  void _handleLevelSelection() {
    _handleUserInteraction();
    HapticFeedback.selectionClick();
    Navigator.pushReplacementNamed(context, '/level-selection');
  }

  void _handleShareAchievement() {
    _handleUserInteraction();
    HapticFeedback.lightImpact();

    final String shareText = completionData["isLastLevel"] as bool
        ? "🎉 I've completed all ${completionData["totalLevels"]} levels in Number Puzzle Master! Total stars: ${completionData["overallStats"]["totalStars"]}/150 ⭐"
        : "🎯 Just completed Level ${completionData["levelNumber"]} in Number Puzzle Master! Time: ${completionData["completionTime"]}, Stars: ${completionData["starsEarned"]}/3 ⭐";

    // Mock share functionality - in real app would use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share text copied: $shareText'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAutoProgress() {
    if (!_userInteracted && (completionData["isNextLevelUnlocked"] as bool)) {
      _handleNextLevel();
    }
  }

  void _handleBackPress() {
    _handleUserInteraction();
    Navigator.pushReplacementNamed(context, '/level-selection');
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black
                  .withValues(alpha: 0.7 * _backgroundAnimation.value),
              child: SafeArea(
                child: GestureDetector(
                  onTap: _handleBackPress,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: GestureDetector(
                      onTap:
                          () {}, // Prevent tap from propagating to background
                      child: AnimatedBuilder(
                        animation: _cardAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _cardAnimation.value,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Container(
                                width: 90.w,
                                constraints: BoxConstraints(
                                  maxHeight: 85.h,
                                  maxWidth: 400,
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(6.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Close Button
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: _handleBackPress,
                                          child: Container(
                                            padding: EdgeInsets.all(2.w),
                                            decoration: BoxDecoration(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.outline
                                                  .withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: CustomIconWidget(
                                              iconName: 'close',
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurfaceVariant,
                                              size: 5.w,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 2.h),

                                      // Completion Celebration
                                      CompletionCelebrationWidget(
                                        levelNumber:
                                            completionData["levelNumber"]
                                                as int,
                                        difficultyLevel:
                                            completionData["difficultyLevel"]
                                                as String,
                                        isLastLevel:
                                            completionData["isLastLevel"]
                                                as bool,
                                      ),

                                      SizedBox(height: 3.h),

                                      // Completion Stats
                                      CompletionStatsWidget(
                                        completionTime:
                                            completionData["completionTime"]
                                                as String,
                                        movesCount:
                                            completionData["movesCount"] as int,
                                        starsEarned:
                                            completionData["starsEarned"]
                                                as int,
                                        personalBest:
                                            completionData["personalBest"]
                                                as String,
                                        isNewRecord:
                                            completionData["isNewRecord"]
                                                as bool,
                                      ),

                                      // Progress Indicator
                                      if (!(completionData["isLastLevel"]
                                          as bool))
                                        ProgressIndicatorWidget(
                                          currentLevel:
                                              completionData["currentLevel"]
                                                  as int,
                                          totalLevels:
                                              completionData["totalLevels"]
                                                  as int,
                                          isNextLevelUnlocked: completionData[
                                              "isNextLevelUnlocked"] as bool,
                                        ),

                                      // Overall Stats for Last Level
                                      if (completionData["isLastLevel"] as bool)
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(4.w),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 2.h),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppTheme.lightTheme.colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.1),
                                                AppTheme.lightTheme.colorScheme
                                                    .secondary
                                                    .withValues(alpha: 0.1),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.primary
                                                  .withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Game Statistics',
                                                style: AppTheme.lightTheme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  color: AppTheme.lightTheme
                                                      .colorScheme.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  _buildOverallStat(
                                                    'Levels',
                                                    '${(completionData["overallStats"] as Map)["totalLevelsCompleted"]}/${completionData["totalLevels"]}',
                                                    'emoji_events',
                                                  ),
                                                  _buildOverallStat(
                                                    'Avg Time',
                                                    (completionData[
                                                                "overallStats"]
                                                            as Map)[
                                                        "averageTime"] as String,
                                                    'schedule',
                                                  ),
                                                  _buildOverallStat(
                                                    'Total Stars',
                                                    '${(completionData["overallStats"] as Map)["totalStars"]}/150',
                                                    'star',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                      SizedBox(height: 2.h),

                                      // Auto Progress Timer
                                      if (!(completionData["isLastLevel"]
                                              as bool) &&
                                          (completionData["isNextLevelUnlocked"]
                                              as bool))
                                        AutoProgressTimerWidget(
                                          onTimerComplete: _handleAutoProgress,
                                          isEnabled: !_userInteracted,
                                          durationSeconds: 5,
                                        ),

                                      SizedBox(height: 2.h),

                                      // Action Buttons
                                      ActionButtonsWidget(
                                        onNextLevel: _handleNextLevel,
                                        onReplayLevel: _handleReplayLevel,
                                        onLevelSelection: _handleLevelSelection,
                                        onShareAchievement:
                                            _handleShareAchievement,
                                        isNextLevelAvailable: completionData[
                                            "isNextLevelUnlocked"] as bool,
                                        isLastLevel:
                                            completionData["isLastLevel"]
                                                as bool,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverallStat(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
