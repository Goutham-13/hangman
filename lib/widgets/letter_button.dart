import 'package:flutter/material.dart';

class LetterButton extends StatelessWidget {
  final String letter;
  final VoidCallback onTap;
  final bool disabled;

  const LetterButton({
    super.key,
    required this.letter,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: disabled ? Colors.grey[300] : Colors.white,
        ),
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Notebook',
            color: disabled ? Colors.grey : const Color(0xFF1D3557),
          ),
        ),
      ),
    );
  }
}
