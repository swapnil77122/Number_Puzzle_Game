import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

enum CellState { normal, highlighted, matched, invalid }

class TutorialGridWidget extends StatefulWidget {
  final Function(int row, int col)? onCellTap;
  final List<List<int?>> gridData;
  final List<List<CellState>> cellStates;
  final bool interactionEnabled;

  const TutorialGridWidget({
    super.key,
    this.onCellTap,
    required this.gridData,
    required this.cellStates,
    this.interactionEnabled = true,
  });

  @override
  State<TutorialGridWidget> createState() => _TutorialGridWidgetState();
}

class _TutorialGridWidgetState extends State<TutorialGridWidget>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  int? _shakingRow;
  int? _shakingCol;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShakeAnimation(int row, int col) {
    setState(() {
      _shakingRow = row;
      _shakingCol = col;
    });
    _shakeController.forward().then((_) {
      _shakeController.reverse().then((_) {
        setState(() {
          _shakingRow = null;
          _shakingCol = null;
        });
      });
    });
  }

  Color _getCellColor(CellState state) {
    switch (state) {
      case CellState.normal:
        return AppTheme.lightTheme.colorScheme.surface;
      case CellState.highlighted:
        return AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3);
      case CellState.matched:
        return AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5);
      case CellState.invalid:
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3);
    }
  }

  Color _getTextColor(CellState state) {
    switch (state) {
      case CellState.normal:
        return AppTheme.lightTheme.colorScheme.onSurface;
      case CellState.highlighted:
        return AppTheme.lightTheme.colorScheme.primary;
      case CellState.matched:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);
      case CellState.invalid:
        return AppTheme.lightTheme.colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: List.generate(widget.gridData.length, (row) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: row < widget.gridData.length - 1 ? 2.w : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(widget.gridData[row].length, (col) {
                final cellValue = widget.gridData[row][col];
                final cellState = widget.cellStates[row][col];
                final isShaking = _shakingRow == row && _shakingCol == col;

                return AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: isShaking
                          ? Offset(
                              _shakeAnimation.value * (row % 2 == 0 ? 1 : -1),
                              0)
                          : Offset.zero,
                      child: GestureDetector(
                        onTap: widget.interactionEnabled && cellValue != null
                            ? () {
                                if (cellState == CellState.invalid) {
                                  _triggerShakeAnimation(row, col);
                                }
                                widget.onCellTap?.call(row, col);
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: _getCellColor(cellState),
                            borderRadius: BorderRadius.circular(2.w),
                            border: Border.all(
                              color: cellState == CellState.highlighted
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                              width: cellState == CellState.highlighted ? 2 : 1,
                            ),
                            boxShadow: cellState == CellState.highlighted
                                ? [
                                    BoxShadow(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : AppTheme.lightElevation,
                          ),
                          child: Center(
                            child: cellValue != null
                                ? Text(
                                    cellValue.toString(),
                                    style:
                                        AppTheme.gameNumberStyle(isLight: true)
                                            .copyWith(
                                      color: _getTextColor(cellState),
                                      fontSize: 18.sp,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
