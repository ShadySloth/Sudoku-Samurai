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
  final SudokuGrid grid = SudokuGrid.example();

  int? selectedCell;

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
                  },
                  child: const Text('OK'),
              ),
            ],
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
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

              setState(() {
                grid.setCell(row, column, number);
              });

              if (grid.isSolved()) {
                showCompletionDialog();
              }
            },
            onClear: () {
              if (selectedCell == null) {
                return;
              }

              final row = selectedCell! ~/ 9;
              final column = selectedCell! % 9;

              if (grid.original[row][column] != null) {
                return;
              }

              setState(() {
                grid.setCell(row, column, null);
              });
            },
          ),
        ],
      ),
    );
  }
}
