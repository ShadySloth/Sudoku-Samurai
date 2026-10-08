class SudokuGrid {
  final List<List<int?>> cells;
  final List<List<int?>> original;
  final List<List<bool>> incorrect;

  SudokuGrid({
    required this.cells,
    required this.original,
    required this.incorrect,
  });

  void setCell(int row, int column, int? value) {
    cells[row][column] = value;

    validateBoard();
  }

  void validateBoard() {
    for (int row = 0; row < 9; row++) {
      for (int column = 0; column < 9; column++) {
        final value = cells[row][column];

        if (original[row][column] != null) {
          incorrect[row][column] = false;
          continue;
        }

        if (value == null) {
          incorrect[row][column] = false;
          continue;
        }

        incorrect[row][column] = !canPlaceNumber(row, column, value);
      }
    }
  }

  bool isSolved() {
    for (int row = 0; row < 9; row++) {
      for (int column = 0; column < 9; column++) {
        if (cells[row][column] == null) {
          return false;
        }

        if (incorrect[row][column]) {
          return false;
        }
      }
    }

    return true;
  }

  void reset() {
    for (int row = 0; row < 9; row++) {
      for (int column = 0; column < 9; column++) {
        cells[row][column] = original[row][column];
        incorrect[row][column] = false;
      }
    }
  }

  bool canPlaceNumber(int row, int column, int number) {
    for (int currentColumn = 0; currentColumn < 9; currentColumn++) {
      if (currentColumn == column) {
        continue;
      }

      if (cells[row][currentColumn] == number) {
        return false;
      }
    }

    for (int currentRow = 0; currentRow < 9; currentRow++) {
      if (currentRow == row) {
        continue;
      }

      if (cells[currentRow][column] == number) {
        return false;
      }
    }

    final boxStartRow = (row ~/ 3) * 3;
    final boxStartColumn = (column ~/ 3) * 3;

    for (
      int currentRow = boxStartRow;
      currentRow < boxStartRow + 3;
      currentRow++
    ) {
      for (
        int currentColumn = boxStartColumn;
        currentColumn < boxStartColumn + 3;
        currentColumn++
      ) {
        if (currentRow == row && currentColumn == column) {
          continue;
        }

        if (cells[currentRow][currentColumn] == number) {
          return false;
        }
      }
    }

    return true;
  }

  factory SudokuGrid.example() {
    final puzzle = [
      [5, 3, null, 6, 7, null, 9, 1, 2],
      [6, null, 2, 1, 9, 5, null, 4, 8],
      [1, 9, 8, null, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9],
    ];

    final incorrect = List.generate(9, (_) => List.generate(9, (_) => false));

    final original = puzzle.map((row) => [...row]).toList();

    return SudokuGrid(cells: puzzle, original: original, incorrect: incorrect);
  }
}
