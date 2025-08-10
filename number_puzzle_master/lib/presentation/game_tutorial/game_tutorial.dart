import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/tutorial_grid_widget.dart';
import './widgets/tutorial_overlay_widget.dart';
import './widgets/tutorial_step_widget.dart';
import './widgets/tutorial_timer_widget.dart';

class GameTutorial extends StatefulWidget {
  const GameTutorial({super.key});

  @override
  State<GameTutorial> createState() => _GameTutorialState();
}

class _GameTutorialState extends State<GameTutorial>
    with TickerProviderStateMixin {
  int _currentStep = 1;
  final int _totalSteps = 6;

  // Tutorial grid data
  List<List<int?>> _gridData = [
    [3, 7, 2, 8],
    [5, 1, 9, 4],
    [6, null, null, null],
  ];

  List<List<CellState>> _cellStates = [
    [CellState.normal, CellState.normal, CellState.normal, CellState.normal],
    [CellState.normal, CellState.normal, CellState.normal, CellState.normal],
    [CellState.normal, CellState.normal, CellState.normal, CellState.normal],
  ];

  int? _selectedRow;
  int? _selectedCol;
  bool _interactionEnabled = true;
  bool _showSuccessMessage = false;
  String _successMessage = '';

  late AnimationController _successController;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  void _showSuccess(String message) {
    setState(() {
      _showSuccessMessage = true;
      _successMessage = message;
    });
    _successController.forward();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _successController.reverse().then((_) {
          setState(() {
            _showSuccessMessage = false;
          });
        });
      }
    });
  }

  void _onCellTap(int row, int col) {
    if (!_interactionEnabled) return;

    final cellValue = _gridData[row][col];
    if (cellValue == null) return;

    HapticFeedback.lightImpact();

    setState(() {
      if (_selectedRow == null && _selectedCol == null) {
        // First selection
        _selectedRow = row;
        _selectedCol = col;
        _cellStates[row][col] = CellState.highlighted;

        if (_currentStep == 1) {
          _showSuccess(
              'Great! You selected a cell. Now tap another cell to match.');
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted && _currentStep == 1) {
              _nextStep();
            }
          });
        }
      } else if (_selectedRow == row && _selectedCol == col) {
        // Deselect same cell
        _cellStates[row][col] = CellState.normal;
        _selectedRow = null;
        _selectedCol = null;
      } else {
        // Second selection - check for match
        final firstValue = _gridData[_selectedRow!][_selectedCol!];
        final secondValue = cellValue;

        if (_isValidMatch(firstValue!, secondValue)) {
          // Valid match
          _cellStates[_selectedRow!][_selectedCol!] = CellState.matched;
          _cellStates[row][col] = CellState.matched;

          if (_currentStep == 2) {
            _showSuccess(
                'Perfect match! Numbers that equal 10 or are the same match.');
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (mounted && _currentStep == 2) {
                _nextStep();
              }
            });
          }
        } else {
          // Invalid match
          _cellStates[_selectedRow!][_selectedCol!] = CellState.invalid;
          _cellStates[row][col] = CellState.invalid;

          if (_currentStep == 3) {
            _showSuccess(
                'That\'s how invalid matches look! They shake and turn red.');
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (mounted && _currentStep == 3) {
                // Reset invalid states
                _cellStates[_selectedRow!][_selectedCol!] = CellState.normal;
                _cellStates[row][col] = CellState.normal;
                _nextStep();
              }
            });
          } else {
            // Reset invalid states after animation
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (mounted) {
                setState(() {
                  _cellStates[_selectedRow!][_selectedCol!] = CellState.normal;
                  _cellStates[row][col] = CellState.normal;
                });
              }
            });
          }
        }

        _selectedRow = null;
        _selectedCol = null;
      }
    });
  }

  bool _isValidMatch(int value1, int value2) {
    return value1 == value2 || value1 + value2 == 10;
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
        _interactionEnabled = true;

        // Reset grid states for new step
        if (_currentStep == 4) {
          // Add row demonstration
          _gridData.add([2, 8, 5, 3]);
          _cellStates.add([
            CellState.normal,
            CellState.normal,
            CellState.normal,
            CellState.normal
          ]);
        }
      });
    } else {
      // Tutorial complete - navigate to level selection
      Navigator.pushReplacementNamed(context, '/level-selection');
    }
  }

  void _skipTutorial() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          title: Text(
            'Skip Tutorial?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to skip the tutorial? You can always replay it later.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Continue Tutorial',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/level-selection');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              ),
              child: Text(
                'Skip',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
        _interactionEnabled = true;

        // Reset states
        _selectedRow = null;
        _selectedCol = null;

        // Reset grid for previous step
        if (_currentStep == 3 && _gridData.length > 3) {
          _gridData.removeLast();
          _cellStates.removeLast();
        }

        // Reset all cell states to normal
        for (int i = 0; i < _cellStates.length; i++) {
          for (int j = 0; j < _cellStates[i].length; j++) {
            _cellStates[i][j] = CellState.normal;
          }
        }
      });
    }
  }

  Widget _getCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return TutorialStepWidget(
          title: 'Welcome to Number Puzzle Master!',
          description:
              'Tap any cell in the grid below to select it. The cell will highlight in blue.',
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          onNext: _nextStep,
          onSkip: _skipTutorial,
          showNextButton: false,
          highlightWidget: TutorialGridWidget(
            gridData: _gridData,
            cellStates: _cellStates,
            onCellTap: _onCellTap,
            interactionEnabled: _interactionEnabled,
          ),
        );

      case 2:
        return TutorialStepWidget(
          title: 'Making Matches',
          description:
              'Now tap another cell to make a match! You can match cells that have the same number OR cells that add up to 10.',
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          onNext: _nextStep,
          onSkip: _skipTutorial,
          showNextButton: false,
          highlightWidget: TutorialGridWidget(
            gridData: _gridData,
            cellStates: _cellStates,
            onCellTap: _onCellTap,
            interactionEnabled: _interactionEnabled,
          ),
        );

      case 3:
        return TutorialStepWidget(
          title: 'Invalid Matches',
          description:
              'Try tapping two cells that don\'t match (not the same number and don\'t add to 10). Watch what happens!',
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          onNext: _nextStep,
          onSkip: _skipTutorial,
          showNextButton: false,
          highlightWidget: TutorialGridWidget(
            gridData: _gridData,
            cellStates: _cellStates,
            onCellTap: _onCellTap,
            interactionEnabled: _interactionEnabled,
          ),
        );

      case 4:
        return TutorialStepWidget(
          title: 'Adding New Rows',
          description:
              'When you need more numbers, new rows are automatically added to the grid. Notice the new row at the bottom!',
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          onNext: _nextStep,
          onSkip: _skipTutorial,
          highlightWidget: TutorialGridWidget(
            gridData: _gridData,
            cellStates: _cellStates,
            onCellTap: _onCellTap,
            interactionEnabled: false,
          ),
        );

      case 5:
        return TutorialStepWidget(
          title: 'Beat the Timer',
          description:
              'Each level has a 2-minute timer. Complete all possible matches before time runs out!',
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          onNext: _nextStep,
          onSkip: _skipTutorial,
          highlightWidget: Column(
            children: [
              const TutorialTimerWidget(
                initialSeconds: 120,
                isActive: false,
              ),
              SizedBox(height: 3.h),
              Text(
                'The timer turns orange when under 30 seconds and red when under 10 seconds.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );

      case 6:
        return TutorialStepWidget(
          title: 'Ready to Play!',
          description:
              'You\'ve learned all the basics! Remember:\n• Match same numbers or numbers that sum to 10\n• Matched cells fade but stay visible\n• Complete levels within 2 minutes\n• Have fun!',
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          onNext: _nextStep,
          onSkip: _skipTutorial,
          showSkipButton: false,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            TutorialOverlayWidget(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        children: [
                          if (_currentStep > 1)
                            IconButton(
                              onPressed: _previousStep,
                              icon: CustomIconWidget(
                                iconName: 'arrow_back',
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 6.w,
                              ),
                            )
                          else
                            SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Tutorial',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 12.w),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Current step content
                    _getCurrentStepContent(),
                  ],
                ),
              ),
            ),

            // Success message overlay
            if (_showSuccessMessage)
              Positioned(
                top: 15.h,
                left: 5.w,
                right: 5.w,
                child: AnimatedBuilder(
                  animation: _successAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _successAnimation.value,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(3.w),
                          boxShadow: AppTheme.mediumElevation,
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 6.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                _successMessage,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
