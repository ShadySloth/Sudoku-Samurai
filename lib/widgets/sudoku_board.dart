import 'package:flutter/material.dart';

import '../models/sudoku_grid.dart';

class SudokuBoard extends StatefulWidget {
  final SudokuGrid grid;
  final int? selectedCell;
  final ValueChanged<int> onCellSelected;

  const SudokuBoard({
    super.key,
    required this.grid,
    required this.selectedCell,
    required this.onCellSelected,
  });

  @override
  State<SudokuBoard> createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {
  int? selectedCell;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
      ),
      itemCount: 81,
      itemBuilder: (context, index) {
        final row = index ~/ 9;
        final column = index % 9;

        final value = widget.grid.cells[row][column];
        final selectedValue = widget.selectedCell == null
            ? null
            : widget.grid.cells[widget.selectedCell! ~/
                  9][widget.selectedCell! % 9];
        final isSameNumber = value != null && value == selectedValue;

        final isGiven = widget.grid.original[row][column] != null;

        final isSelected = widget.selectedCell == index;
        final selectedRow = widget.selectedCell == null
            ? null
            : widget.selectedCell! ~/ 9;
        final selectedColumn = widget.selectedCell == null
            ? null
            : widget.selectedCell! % 9;

        final isSameRow = selectedRow != null && row == selectedRow;
        final isSameColumn = selectedColumn != null && column == selectedColumn;
        final isSameBox =
            selectedCell != null &&
            row ~/ 3 == selectedRow! ~/ 3 &&
            column ~/ 3 == selectedColumn! ~/ 3;

        final isHighlighted =
            isSelected ||
            isSameRow ||
            isSameColumn ||
            isSameBox ||
            isSameNumber;

        final isBoxRight = column == 2 || column == 5;
        final isboxBottom = row == 2 || row == 5;

        return GestureDetector(
          onTap: () {
            widget.onCellSelected(index);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.shade200
                  : isSameNumber
                      ? Colors.orange.shade100
                      : isHighlighted
                          ? Colors.blue.shade50
                          : Colors.white,
              border: Border(
                top: const BorderSide(color: Colors.black),
                left: const BorderSide(color: Colors.black),
                right: BorderSide(
                  color: Colors.black,
                  width: isBoxRight ? 3 : 1,
                ),
                bottom: BorderSide(
                  color: Colors.black,
                  width: isboxBottom ? 3 : 1,
                ),
              ),
            ),
            child: Center(
              child: Text(
                value?.toString() ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: isGiven ? FontWeight.bold : FontWeight.normal,
                  color: isGiven
                      ? Colors.black
                      : widget.grid.incorrect[row][column]
                      ? Colors.red
                      : Colors.blue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
