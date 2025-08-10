import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class GameGridWidget extends StatelessWidget {
  final List<List<int?>> gridData;
  final List<List<bool>> matchedCells;
  final List<List<bool>> highlightedCells;
  final Function(int, int) onCellTap;

  const GameGridWidget({
    Key? key,
    required this.gridData,
    required this.matchedCells,
    required this.highlightedCells,
    required this.onCellTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: List.generate(gridData.length, (rowIndex) {
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(gridData[rowIndex].length, (colIndex) {
                final cellValue = gridData[rowIndex][colIndex];
                final isMatched = matchedCells[rowIndex][colIndex];
                final isHighlighted = highlightedCells[rowIndex][colIndex];

                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    child: _buildGridCell(
                      context,
                      cellValue,
                      isMatched,
                      isHighlighted,
                      rowIndex,
                      colIndex,
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGridCell(
    BuildContext context,
    int? value,
    bool isMatched,
    bool isHighlighted,
    int row,
    int col,
  ) {
    return GestureDetector(
      onTap: value != null && !isMatched ? () => onCellTap(row, col) : null,
      child: AnimatedContainer(
        duration: AppTheme.normalAnimation,
        height: 12.h,
        decoration: BoxDecoration(
          color: _getCellColor(context, isMatched, isHighlighted),
          border: Border.all(
            color: isHighlighted
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isHighlighted ? 2.0 : 1.0,
          ),
          borderRadius: AppTheme.mediumRadius,
          boxShadow: isHighlighted ? AppTheme.lightElevation : null,
        ),
        child: Center(
          child: value != null
              ? Text(
                  value.toString(),
                  style: AppTheme.gameNumberStyle(isLight: true).copyWith(
                    color: isMatched
                        ? AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.4)
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Color _getCellColor(
      BuildContext context, bool isMatched, bool isHighlighted) {
    if (isMatched) {
      return AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.3);
    }
    if (isHighlighted) {
      return AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
    }
    return AppTheme.lightTheme.colorScheme.surface;
  }
}
