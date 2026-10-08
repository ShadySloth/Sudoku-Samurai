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

  bool _fillBoard(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int column = 0; column < 9; column++) {
        if (board[row][column] != 0) {
          continue;
        }

        final numbers = List.generate(9, (index) => index + 1);
        numbers.shuffle(_random);

        for (final number in numbers) {

        }
      }
    }
  }
}