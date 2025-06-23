import 'package:flutter/material.dart';
import '../services/movie_services.dart';
import '../models/movie_model.dart';
import '../widgets/hangman_painter.dart';
import '../widgets/letter_button.dart';
import '../widgets/score_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final MovieService movieService = MovieService();
  Movie? currentMovie;
  List<String> guessed = [];
  List<String> hintedLetters = [];
  int wrong = 0;
  int score = 0;
  int hintCount = 3;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMovie();
  }

  void loadMovie() async {
    setState(() => loading = true);
    final movie = await movieService.fetchRandomMalayalamMovie();
    guessed = [];
    hintedLetters = [];
    wrong = 0;
    hintCount = 3;
    setState(() {
      currentMovie = movie;
      loading = false;
    });
  }

  void onLetterTap(String letter) {
    if (currentMovie == null || guessed.contains(letter)) return;

    setState(() {
      guessed.add(letter);
      if (!currentMovie!.title.contains(letter)) {
        wrong++;
      }
    });

    final allGuessed = currentMovie!.title
        .replaceAll(RegExp(r'[^A-Z]'), '')
        .split('')
        .every((char) => guessed.contains(char) || hintedLetters.contains(char));

    if (allGuessed || wrong >= 6) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          title: Text(
            allGuessed ? '🎉 Well Done!' : '😅 You Lost!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontFamily: 'Notebook'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Text(
                'The Movie Was:',
                style: TextStyle(fontSize: 16, fontFamily: 'Notebook'),
              ),
              const SizedBox(height: 4),
              Text(
                currentMovie!.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'Notebook',
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  side: const BorderSide(color: Colors.blue, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    if (allGuessed) {
                      score++; // ✅ increase on win
                    } else {
                      score = 0; // ❌ reset on lose
                    }
                  });
                  loadMovie();
                },
                child: Text(
                  allGuessed ? 'Next Level' : 'Try Again',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Notebook',
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    }
  }

  void useHint() {
    if (currentMovie == null || hintCount <= 0) return;

    final unguessedLetters = currentMovie!.title
        .replaceAll(RegExp(r'[^A-Z]'), '')
        .split('')
        .where((char) =>
            !guessed.contains(char) && !hintedLetters.contains(char))
        .toList();

    if (unguessedLetters.isNotEmpty) {
      unguessedLetters.shuffle();
      setState(() {
        hintedLetters.add(unguessedLetters.first);
        hintCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final title = currentMovie!.title;
    final clue = currentMovie!.clue;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/notebook_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ScoreDisplay(score: score),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Clue box
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  clue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontFamily: 'Notebook'),
                ),
              ),
              const SizedBox(height: 20),

              // Hangman drawing
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 200,
                child: CustomPaint(painter: HangmanPainter(wrong)),
              ),

              // Word puzzle (movie title)
              Wrap(
                alignment: WrapAlignment.center,
                children: title.split('').map((c) {
                  final isLetter = RegExp(r'[A-Z]').hasMatch(c);
                  final guessedChar = guessed.contains(c);
                  final hintedChar = hintedLetters.contains(c);

                  Color color = Colors.black54;
                  if (guessedChar) color = const Color(0xFF0047AB); // Blue ink
                  if (hintedChar) color = const Color(0xFFD62828); // Red ink

                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      isLetter ? (guessedChar || hintedChar ? c : '_') : c,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontFamily: 'Notebook',
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Letter Buttons
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
                      return LetterButton(
                        letter: letter,
                        onTap: () => onLetterTap(letter),
                        disabled: guessed.contains(letter) || hintedLetters.contains(letter),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Hint Button
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: hintCount > 0 ? useHint : null,
                icon: Icon(Icons.lightbulb_outline,
                    color: hintCount > 0 ? Colors.orange : Colors.grey),
                label: Text(
                  'Hint ($hintCount left)',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Notebook',
                    color: hintCount > 0 ? Colors.orange : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
