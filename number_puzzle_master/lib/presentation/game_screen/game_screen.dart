import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/game_controls_widget.dart';
import './widgets/game_grid_widget.dart';
import './widgets/game_timer_widget.dart';
import './widgets/match_animation_widget.dart';
import './widgets/pause_dialog_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Game state variables
  List<List<int?>> _gridData = [];
  List<List<bool>> _matchedCells = [];
  List<List<bool>> _highlightedCells = [];

  // Game logic variables
  int? _firstSelectedRow;
  int? _firstSelectedCol;
  int _remainingSeconds = 120; // 2 minutes
  Timer? _gameTimer;
  bool _isPaused = false;
  bool _isGameComplete = false;
  int _score = 0;
  int _currentLevel = 1;

  // Animation state
  bool _showSuccessAnimation = false;
  bool _showErrorAnimation = false;

  // Mock game data
  final List<List<int?>> _initialGameData = [
    [3, 7, 2, 8, 1],
    [9, 4, 6, null, 5],
    [1, null, 8, 2, 7],
    [null, 5, 3, 9, 4],
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    _gridData = _initialGameData.map((row) => List<int?>.from(row)).toList();
    _matchedCells = List.generate(
      _gridData.length,
      (index) => List.generate(_gridData[index].length, (index) => false),
    );
    _highlightedCells = List.generate(
      _gridData.length,
      (index) => List.generate(_gridData[index].length, (index) => false),
    );
    _firstSelectedRow = null;
    _firstSelectedCol = null;
    _score = 0;
    _remainingSeconds = 120;
    _isGameComplete = false;
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && !_isGameComplete) {
        setState(() {
          _remainingSeconds--;
          if (_remainingSeconds <= 0) {
            _gameOver();
          }
        });
      }
    });
  }

  void _onCellTap(int row, int col) {
    if (_isPaused || _isGameComplete || _matchedCells[row][col]) return;

    HapticFeedback.lightImpact();

    setState(() {
      if (_firstSelectedRow == null || _firstSelectedCol == null) {
        // First cell selection
        _clearHighlights();
        _firstSelectedRow = row;
        _firstSelectedCol = col;
        _highlightedCells[row][col] = true;
      } else if (_firstSelectedRow == row && _firstSelectedCol == col) {
        // Deselect the same cell
        _clearHighlights();
        _firstSelectedRow = null;
        _firstSelectedCol = null;
      } else {
        // Second cell selection - check for match
        final firstValue = _gridData[_firstSelectedRow!][_firstSelectedCol!];
        final secondValue = _gridData[row][col];

        if (_isValidMatch(firstValue, secondValue)) {
          _handleSuccessfulMatch(row, col);
        } else {
          _handleFailedMatch();
        }
      }
    });
  }

  bool _isValidMatch(int? value1, int? value2) {
    if (value1 == null || value2 == null) return false;
    return value1 == value2 || (value1 + value2 == 10);
  }

  void _handleSuccessfulMatch(int row, int col) {
    // Mark cells as matched
    _matchedCells[_firstSelectedRow!][_firstSelectedCol!] = true;
    _matchedCells[row][col] = true;

    // Clear highlights
    _clearHighlights();

    // Update score
    _score += 10;

    // Show success animation
    _showSuccessAnimation = true;

    // Reset selection
    _firstSelectedRow = null;
    _firstSelectedCol = null;

    // Check for level completion
    _checkLevelCompletion();
  }

  void _handleFailedMatch() {
    HapticFeedback.heavyImpact();

    // Show error animation
    _showErrorAnimation = true;

    // Clear highlights after a brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _clearHighlights();
          _firstSelectedRow = null;
          _firstSelectedCol = null;
        });
      }
    });
  }

  void _clearHighlights() {
    for (int i = 0; i < _highlightedCells.length; i++) {
      for (int j = 0; j < _highlightedCells[i].length; j++) {
        _highlightedCells[i][j] = false;
      }
    }
  }

  void _checkLevelCompletion() {
    bool allMatched = true;
    for (int i = 0; i < _gridData.length; i++) {
      for (int j = 0; j < _gridData[i].length; j++) {
        if (_gridData[i][j] != null && !_matchedCells[i][j]) {
          allMatched = false;
          break;
        }
      }
      if (!allMatched) break;
    }

    if (allMatched) {
      _isGameComplete = true;
      _gameTimer?.cancel();
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/level-complete');
        }
      });
    }
  }

  void _addRow() {
    if (_gridData.length >= 8) return; // Maximum 8 rows

    setState(() {
      // Generate a new row with random numbers
      final Random random = Random();
      final List<int?> newRow = List.generate(5, (index) {
        return random.nextBool() ? random.nextInt(9) + 1 : null;
      });

      _gridData.add(newRow);
      _matchedCells.add(List.generate(5, (index) => false));
      _highlightedCells.add(List.generate(5, (index) => false));
    });
  }

  void _pauseGame() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeGame() {
    setState(() {
      _isPaused = false;
    });
  }

  void _restartGame() {
    setState(() {
      _isPaused = false;
      _initializeGame();
      _startTimer();
    });
  }

  void _quitGame() {
    Navigator.pushReplacementNamed(context, '/level-selection');
  }

  void _gameOver() {
    _isGameComplete = true;
    _gameTimer?.cancel();
    Navigator.pushReplacementNamed(context, '/game-over');
  }

  void _onAnimationComplete() {
    setState(() {
      _showSuccessAnimation = false;
      _showErrorAnimation = false;
    });
  }

  Future<bool> _onWillPop() async {
    if (!_isPaused) {
      _pauseGame();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Timer and level header
                  GameTimerWidget(
                    remainingSeconds: _remainingSeconds,
                    onPause: _pauseGame,
                  ),

                  // Score display
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: Colors.amber,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Score: $_score',
                          style: AppTheme.gameScoreStyle(isLight: true),
                        ),
                      ],
                    ),
                  ),

                  // Game grid
                  Expanded(
                    child: SingleChildScrollView(
                      child: GameGridWidget(
                        gridData: _gridData,
                        matchedCells: _matchedCells,
                        highlightedCells: _highlightedCells,
                        onCellTap: _onCellTap,
                      ),
                    ),
                  ),

                  // Game controls
                  GameControlsWidget(
                    onAddRow: _addRow,
                    onRestart: _restartGame,
                    canAddRow: _gridData.length < 8,
                  ),
                ],
              ),

              // Pause dialog overlay
              if (_isPaused)
                PauseDialogWidget(
                  onResume: _resumeGame,
                  onRestart: _restartGame,
                  onQuit: _quitGame,
                ),

              // Match animation overlay
              if (_showSuccessAnimation || _showErrorAnimation)
                MatchAnimationWidget(
                  showSuccess: _showSuccessAnimation,
                  showError: _showErrorAnimation,
                  onAnimationComplete: _onAnimationComplete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
