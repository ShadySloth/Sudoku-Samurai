import 'package:flutter/material.dart';

import 'models/sudoku_grid.dart';
import 'widgets/sudoku_board.dart';

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

class _HomeScreenState extends State<HomeScreen>{
  final SudokuGrid grid = SudokuGrid.example();

  int? selectedCell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SudokuBoard(grid: grid,
        selectedCell: selectedCell,
        onCellSelected: (index) {
          setState(() {
            selectedCell = index;
          });
        }
      ),
    );
  }
}
