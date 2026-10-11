import 'dart:math';

class SudokuGenerator {
  final Random _random = Random();

  List<List<int>> generateSolvedBoard() {
    final board = List.generate(9, (_) => List.generate(9, (_) => 0));

    _fillBoard(board);

    return board;
  }

  List<List<int?>> generatePuzzle({String difficulty = 'Medium'}) {
    final (minimumScore, maximumScore) = getDifficultyScoreRange(difficulty);

    final solvedBoard = generateSolvedBoard();

    final puzzle = solvedBoard
        .map((row) => row.map<int?>((value) => value).toList())
        .toList();

    List<List<int?>>? bestPuzzle;
    int bestScore = -1;

    final positions = List.generate(81, (index) => index);
    positions.shuffle(_random);

    for (final position in positions) {
      final row = position ~/ 9;
      final column = position % 9;

      final savedValue = puzzle[row][column]!;
      puzzle[row][column] = null;

      final boardToCheck = puzzle
          .map((row) => row.map((value) => value ?? 0).toList())
          .toList();

      if (countSolutions(boardToCheck) != 1) {
        puzzle[row][column] = savedValue;
        continue;
      }

      final score = calculateDifficultyScore(puzzle);

      if (score >= minimumScore && score <= maximumScore) {
        if (score > bestScore) {
          bestScore = score;

          bestPuzzle = puzzle.map((row) => [...row]).toList();
        }
      }

      if (score > maximumScore) {
        break;
      }
    }

    return bestPuzzle ?? puzzle;
  }

  (int, int) getDifficultyScoreRange(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return (1, 39);

      case 'Medium':
        return (40, 99);

      case 'Hard':
        return (100, 200);

      default:
        return (40, 99);
    }
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

  List<int> getCandidates(List<List<int>> board, int row, int column) {
    if (board[row][column] != 0) {
      return [];
    }

    final candidates = <int>[];

    for (int number = 1; number <= 9; number++) {
      if (_canPlaceNumber(board, row, column, number)) {
        candidates.add(number);
      }
    }

    return candidates;
  }

  int solveNakedSingles(List<List<int>> board) {
    int steps = 0;

    for (int row = 0; row < 9; row++) {
      for (int column = 0; column < 9; column++) {
        if (board[row][column] != 0) {
          continue;
        }

        final candidates = getCandidates(board, row, column);

        if (candidates.length == 1) {
          board[row][column] = candidates.first;
          steps++;
        }
      }
    }

    return steps;
  }

  int solveHiddenSingles(List<List<int>> board) {
    int steps = 0;

    for (int row = 0; row < 9; row++) {
      for (int number = 1; number <= 9; number++) {
        int? candidateColumn;
        int count = 0;

        for (int column = 0; column < 9; column++) {
          if (board[row][column] != 0) {
            continue;
          }

          if (getCandidates(board, row, column).contains(number)) {
            candidateColumn = column;
            count++;
          }
        }

        if (count == 1) {
          board[row][candidateColumn!] = number;
          steps++;
        }
      }
    }

    for (int column = 0; column < 9; column++) {
      for (int number = 1; number <= 9; number++) {
        int? candidateRow;
        int count = 0;

        for (int row = 0; row < 9; row++) {
          if (board[row][column] != 0) {
            continue;
          }

          if (getCandidates(board, row, column).contains(number)) {
            candidateRow = row;
            count++;
          }
        }

        if (count == 1) {
          board[candidateRow!][column] = number;
          steps++;
        }
      }
    }

    for (int boxRow = 0; boxRow < 9; boxRow += 3) {
      for (int boxColumn = 0; boxColumn < 9; boxColumn += 3) {
        for (int number = 1; number <= 9; number++) {
          int? candidateRow;
          int? candidateColumn;
          int count = 0;

          for (int row = boxRow; row < boxRow + 3; row++) {
            for (int column = boxColumn; column < boxColumn + 3; column++) {
              if (board[row][column] != 0) {
                continue;
              }

              if (getCandidates(board, row, column).contains(number)) {
                candidateRow = row;
                candidateColumn = column;
                count++;
              }
            }
          }

          if (count == 1) {
            board[candidateRow!][candidateColumn!] = number;
            steps++;
          }
        }
      }
    }

    return steps;
  }

  int solveSingles(List<List<int>> board) {
    int steps = 0;

    while (true) {
      final nakedSingles = solveNakedSingles(board);

      if (nakedSingles > 0) {
        steps += nakedSingles;
        continue;
      }

      final hiddenSingles = solveHiddenSingles(board);

      if (hiddenSingles > 0) {
        steps += hiddenSingles;
        continue;
      }

      break;
    }

    return steps;
  }

  int calculateDifficultyScore(List<List<int?>> puzzle) {
    final board = puzzle
        .map((row) => row.map((value) => value ?? 0).toList())
        .toList();

    int score = 0;

    final nakedSingles = solveNakedSingles(board);
    score += nakedSingles;

    final hiddenSingles = solveHiddenSingles(board);
    score += hiddenSingles * 2;

    final remainingEmptyCells = board
        .expand((row) => row)
        .where((value) => value == 0)
        .length;

    if (remainingEmptyCells > 0) {
      score += 100;
    }

    return score;
  }

  String difficultyFromScore(int score) {
    if (score < 40) {
      return 'Easy';
    }

    if (score < 100) {
      return 'Medium';
    }

    return 'Hard';
  }

  void testSolver() {
    final puzzle = generatePuzzle(difficulty: 'Easy');

    final score = calculateDifficultyScore(puzzle);

    print('Difficulty score: $score');
    print('Difficulty: ${difficultyFromScore(score)}');
  }
}
