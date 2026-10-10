import 'dart:math';

class SudokuGenerator {
  final Random _random = Random();

  List<List<int>> generateSolvedBoard() {
    final board = List.generate(
      9,
        (_) => List.generate(9, (_) => 0),
    );

    _fillBoard(board);

    return board;
  }

  List<List<int?>> generatePuzzle({int emptyCells = 40}) {
    final solvedBoard = generateSolvedBoard();

    final puzzle = solvedBoard
        .map((row) => row.map<int?>((value) => value).toList())
        .toList();

    final positions = List.generate(81, (index) => index);
    positions.shuffle(_random);

    for (int i = 0; i < emptyCells && i < positions.length; i++) {
      final row = positions[i] ~/ 9;
      final column = positions[i] % 9;

      puzzle[row][column] = null;
    }

    return puzzle;
  }

  bool _fillBoard(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int column = 0; column < 9; column++) {
        if (board[row][column] != 0) {
          continue;
        }

        final numbers = List.generate(9, (index) => index + 1);
        numbers.shuffle(_random);

        for (final number in numbers) {
          if (!_canPlaceNumber(board, row, column, number)) {
            continue;
          }

          board[row][column] = number;

          if (_fillBoard(board)) {
            return true;
          }

          board[row][column] = 0;
        }

        return false;
      }
    }

    return true;
  }

  bool _canPlaceNumber(List<List<int>> board, int row, int column, int number) {
    for (int currentColumn = 0; currentColumn < 9; currentColumn++) {
      if (board[row][currentColumn] == number) {
        return false;
      }
    }

    for (int currentRow = 0; currentRow < 9; currentRow++) {
      if (board[currentRow][column] == number) {
        return false;
      }
    }

    final boxStartRow = (row ~/ 3) * 3;
    final boxStartColumn = (column ~/ 3) * 3;

    for (int currentRow = boxStartRow; currentRow < boxStartRow + 3; currentRow++) {
      for (int currentColumn = boxStartColumn; currentColumn < boxStartColumn + 3; currentColumn++) {
        if (board[currentRow][currentColumn] == number) {
          return false;
        }
      }
    }

    return true;
  }
}