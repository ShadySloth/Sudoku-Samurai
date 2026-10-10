import 'dart:async';

import 'package:flutter/material.dart';

import 'models/sudoku_grid.dart';
import 'widgets/sudoku_board.dart';
import 'widgets/number_pad.dart';

void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SudokuGrid grid;

  int? selectedCell;
  int moves = 0;
  int mistakes = 0;
  int elapsedSeconds = 0;
  Timer? gameTimer;
  String difficulty = 'Medium';

  int get emptyCellsForDifficulty {
    switch (difficulty) {
      case 'Easy':
        return 30;
      case 'Medium':
        return 40;
      case 'Hard':
        return 50;
      default:
        return 40;
    }
  }

  @override
  void initState() {
    super.initState();
    grid = SudokuGrid.fromGeneratedPuzzle(emptyCells: emptyCellsForDifficulty);
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (gameTimer != null) {
      return;
    }

    gameTimer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          setState(() {
            elapsedSeconds++;
          });
        }
    );
  }

  String formatTime() {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sudoku Complete! 🎉'),
          content: const Text('Congratulations! You solved the puzzle.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startNewGame();
              },
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }

  void startNewGame() {
    gameTimer?.cancel();
    gameTimer = null;

    setState(() {
      grid = SudokuGrid.fromGeneratedPuzzle(emptyCells: emptyCellsForDifficulty);
      selectedCell = null;
      moves = 0;
      mistakes = 0;
      elapsedSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Difficulty',
            initialValue: difficulty,
            onSelected: (value) {
              setState(() {
                difficulty = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'Easy',
                child: Text('Easy'),
              ),
              PopupMenuItem(
                value: 'Medium',
                child: Text('Medium'),
              ),
              PopupMenuItem(
                value: 'Hard',
                child: Text('Hard'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(difficulty),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'New Game',
            onPressed: startNewGame,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Moves'),
                    Text(
                      '$moves',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Mistakes'),
                    Text(
                      '$mistakes',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Time'),
                    Text(
                      formatTime(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
          Expanded(
            child: SudokuBoard(
              grid: grid,
              selectedCell: selectedCell,
              onCellSelected: (index) {
                setState(() {
                  selectedCell = index;
                });
              },
            ),
          ),
          NumberPad(
            onNumberSelected: (number) {
              if (selectedCell == null) {
                return;
              }

              final row = selectedCell! ~/ 9;
              final column = selectedCell! % 9;

              if (grid.original[row][column] != null) {
                return;
              }

              startTimer();

              setState(() {
                grid.setCell(row, column, number);
                moves++;

                if (grid.incorrect[row][column]) {
                  mistakes++;
                }
              });

              if (grid.isSolved()) {
                gameTimer?.cancel();
                gameTimer = null;

                showCompletionDialog();
              }
            },
          ),
        ],
      ),
    );
  }
}
