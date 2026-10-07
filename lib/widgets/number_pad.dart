import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final ValueChanged<int> onNumberSelected;
  final VoidCallback onClear;

  const NumberPad({
    super.key,
    required this.onNumberSelected,
    required this.onClear
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        ...List.generate(9, (index) {
        final number = index + 1;

        return Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
              onPressed: () {
                onNumberSelected(number);
              },
              child: Text('$number'),
          ),
        );
      }),
        Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
              onPressed: onClear,
              child: const Text('⌫'))
        )
      ],
    );
  }
}
