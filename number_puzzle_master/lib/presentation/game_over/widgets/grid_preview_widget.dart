import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GridPreviewWidget extends StatelessWidget {
  final List<List<int?>> gridData;
  final List<List<bool>> matchedCells;

  const GridPreviewWidget({
    Key? key,
    required this.gridData,
    required this.matchedCells,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'grid_view',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Your Progress',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildGrid(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 25.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            gridData.length,
            (rowIndex) => _buildGridRow(rowIndex),
          ),
        ),
      ),
    );
  }

  Widget _buildGridRow(int rowIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          gridData[rowIndex].length,
          (colIndex) => _buildGridCell(rowIndex, colIndex),
        ),
      ),
    );
  }

  Widget _buildGridCell(int row, int col) {
    final cellValue = gridData[row][col];
    final isMatched = matchedCells[row][col];

    return Container(
      width: 12.w,
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 0.5.w),
      decoration: BoxDecoration(
        color: cellValue != null
            ? (isMatched
                ? AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5)
                : AppTheme.lightTheme.colorScheme.surface)
            : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isMatched
              ? AppTheme.successLight.withValues(alpha: 0.5)
              : AppTheme.lightTheme.dividerColor,
          width: isMatched ? 2 : 1,
        ),
      ),
      child: Center(
        child: cellValue != null
            ? Text(
                cellValue.toString(),
                style: AppTheme.gameNumberStyle(isLight: true).copyWith(
                  fontSize: 14.sp,
                  color: isMatched
                      ? AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5)
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              )
            : null,
      ),
    );
  }
}
