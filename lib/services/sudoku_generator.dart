import 'dart:math';

class SudokuGenerator {
  final Random _random = Random();

  List<List<int>> generateSolvedBoard() {
    final board = List.generate(9, (_) => List.generate(9, (_) => 0));

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

    int removed = 0;

    for (final position in positions) {
      if (removed >= emptyCells) {
        break;
      }

      final row = position ~/ 9;
      final column = position % 9;

      final savedValue = puzzle[row][column]!;
      puzzle[row][column] = null;

      final boardToCheck = puzzle.map(
            (row) => row.map((value) => value ?? 0).toList(),
      ).toList();

      if (countSolutions(boardToCheck) == 1) {
        removed++;
      } else {
        puzzle[row][column] = savedValue;
      }
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
        if (board[currentRow][currentColumn] == number) {
          return false;
        }
      }
    }

    return true;
  }

  int countSolutions(List<List<int>> board) {
    int count = 0;

    void solve() {
      if (count >= 2) {
        return;
      }

      int? emptyRow;
      int? emptyColumn;

      for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
          if (board[row][column] == 0) {
            emptyRow = row;
            emptyColumn = column;
            break;
          }
        }

        if (emptyRow != null) {
          break;
        }
      }

      if (emptyRow == null) {
        count++;
        return;
      }

      for (int number = 1; number <= 9; number++) {
        if (!_canPlaceNumber(board, emptyRow, emptyColumn!, number)) {
          continue;
        }

        board[emptyRow][emptyColumn] = number;
        solve();
        board[emptyRow][emptyColumn] = 0;

        if (count >= 2) {
          return;
        }
      }
    }

    solve();
    return count;
  }
}
