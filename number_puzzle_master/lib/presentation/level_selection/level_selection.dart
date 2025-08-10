import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/level_card_widget.dart';
import './widgets/level_context_menu_widget.dart';
import './widgets/progress_header_widget.dart';

class LevelSelection extends StatefulWidget {
  const LevelSelection({Key? key}) : super(key: key);

  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _selectedLevelForMenu;
  bool _isRefreshing = false;

  // Mock data for levels
  final List<Map<String, dynamic>> _levelsData = [
    {
      "levelNumber": 1,
      "difficulty": "Easy",
      "isLocked": false,
      "stars": 3,
      "bestTime": "1:23",
      "isCompleted": true,
    },
    {
      "levelNumber": 2,
      "difficulty": "Easy",
      "isLocked": false,
      "stars": 2,
      "bestTime": "1:45",
      "isCompleted": true,
    },
    {
      "levelNumber": 3,
      "difficulty": "Easy",
      "isLocked": false,
      "stars": 1,
      "bestTime": "1:58",
      "isCompleted": true,
    },
    {
      "levelNumber": 4,
      "difficulty": "Easy",
      "isLocked": false,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 5,
      "difficulty": "Easy",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 6,
      "difficulty": "Easy",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 7,
      "difficulty": "Easy",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 8,
      "difficulty": "Easy",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 9,
      "difficulty": "Easy",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 10,
      "difficulty": "Easy",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 11,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 12,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 13,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 14,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 15,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 16,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 17,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 18,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 19,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 20,
      "difficulty": "Medium",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 21,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 22,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 23,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 24,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 25,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 26,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 27,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 28,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 29,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
    {
      "levelNumber": 30,
      "difficulty": "Hard",
      "isLocked": true,
      "stars": 0,
      "bestTime": null,
      "isCompleted": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedLevels = (_levelsData as List)
        .where((level) => level['isCompleted'] as bool)
        .length;
    final totalLevels = _levelsData.length;
    final completionPercentage = (completedLevels / totalLevels) * 100;
    final hasCompletedLevels = completedLevels > 0;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Number Puzzle Master',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'games',
                color: _tabController.index == 0
                    ? AppTheme.lightTheme.tabBarTheme.labelColor!
                    : AppTheme.lightTheme.tabBarTheme.unselectedLabelColor!,
                size: 5.w,
              ),
              text: 'Game',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'grid_view',
                color: _tabController.index == 1
                    ? AppTheme.lightTheme.tabBarTheme.labelColor!
                    : AppTheme.lightTheme.tabBarTheme.unselectedLabelColor!,
                size: 5.w,
              ),
              text: 'Levels',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'settings',
                color: _tabController.index == 2
                    ? AppTheme.lightTheme.tabBarTheme.labelColor!
                    : AppTheme.lightTheme.tabBarTheme.unselectedLabelColor!,
                size: 5.w,
              ),
              text: 'Settings',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGameTab(),
          _buildLevelsTab(completionPercentage, completedLevels, totalLevels,
              hasCompletedLevels),
          _buildSettingsTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 1 && hasCompletedLevels
          ? FloatingActionButton.extended(
              onPressed: _selectRandomLevel,
              icon: CustomIconWidget(
                iconName: 'shuffle',
                color: AppTheme
                    .lightTheme.floatingActionButtonTheme.foregroundColor!,
                size: 5.w,
              ),
              label: Text(
                'Random Level',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme
                      .lightTheme.floatingActionButtonTheme.foregroundColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor:
                  AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
            )
          : null,
    );
  }

  Widget _buildGameTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'games',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 15.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'Game Overview',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Welcome to Number Puzzle Master! Navigate to the Levels tab to start your puzzle journey.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelsTab(double completionPercentage, int completedLevels,
      int totalLevels, bool hasCompletedLevels) {
    if (!hasCompletedLevels) {
      return EmptyStateWidget(
        onStartJourney: () => _navigateToLevel(1),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshLevels,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProgressHeaderWidget(
              completionPercentage: completionPercentage,
              overallBestTime: "1:23",
              totalLevels: totalLevels,
              completedLevels: completedLevels,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getCrossAxisCount(),
                childAspectRatio: 0.8,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 2.h,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final levelData = _levelsData[index];
                  return LevelCardWidget(
                    levelData: levelData,
                    onTap: () =>
                        _navigateToLevel(levelData['levelNumber'] as int),
                    onLongPress: (levelData['stars'] as int) > 0
                        ? () => _showContextMenu(levelData)
                        : null,
                  );
                },
                childCount: _levelsData.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 15.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'Settings',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Game settings and preferences will be available here.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount() {
    if (100.w > 600) {
      return 3; // Tablet view
    }
    return 2; // Mobile view
  }

  Future<void> _refreshLevels() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _navigateToLevel(int levelNumber) {
    Navigator.pushNamed(context, '/game-screen');
  }

  void _selectRandomLevel() {
    final unlockedLevels = (_levelsData as List)
        .where((level) => !(level['isLocked'] as bool))
        .toList();

    if (unlockedLevels.isNotEmpty) {
      final randomLevel =
          unlockedLevels[DateTime.now().millisecond % unlockedLevels.length];
      _navigateToLevel(randomLevel['levelNumber'] as int);
    }
  }

  void _showContextMenu(Map<String, dynamic> levelData) {
    setState(() {
      _selectedLevelForMenu = levelData;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.all(4.w),
        child: LevelContextMenuWidget(
          levelData: levelData,
          onRestart: () {
            Navigator.pop(context);
            _navigateToLevel(levelData['levelNumber'] as int);
          },
          onViewScore: () {
            Navigator.pop(context);
            _showScoreDialog(levelData);
          },
          onShare: () {
            Navigator.pop(context);
            _shareAchievement(levelData);
          },
          onClose: () => Navigator.pop(context),
        ),
      ),
    ).then((_) {
      setState(() {
        _selectedLevelForMenu = null;
      });
    });
  }

  void _showScoreDialog(Map<String, dynamic> levelData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Level ${levelData['levelNumber']} Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Difficulty: ${levelData['difficulty']}'),
            SizedBox(height: 1.h),
            Text('Stars Earned: ${levelData['stars']}/3'),
            SizedBox(height: 1.h),
            Text('Best Time: ${levelData['bestTime'] ?? 'N/A'}'),
            SizedBox(height: 1.h),
            Text(
                'Status: ${levelData['isCompleted'] ? 'Completed' : 'In Progress'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _shareAchievement(Map<String, dynamic> levelData) {
    // Simulate sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Shared Level ${levelData['levelNumber']} achievement with ${levelData['stars']} stars!',
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}
