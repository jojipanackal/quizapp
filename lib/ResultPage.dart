import 'package:flutter/material.dart';
import 'package:flutter_pie_chart/flutter_pie_chart.dart';
import 'StartQuizPage.dart';

class ResultPage extends StatelessWidget {
  final int correctAnswers;
  final List<Map<String, dynamic>> questions;
  final int totalTime;

  ResultPage({required this.correctAnswers, required this.questions, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    final int totalQuestions = questions.length;
    final int incorrectAnswers = totalQuestions - correctAnswers;

    final List<Pie> pies = [
      Pie(color: Colors.red, proportion: incorrectAnswers.toDouble()),
      Pie(color: Colors.green, proportion: correctAnswers.toDouble()),
    ];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Results',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 6),
            Text(
              correctAnswers > 12 ? "😎" : correctAnswers >= 10 ? "🥳" : correctAnswers > 5 ? "😌" : "🙂",
              style: TextStyle(fontSize: 50),
            ),
            Text(
              'You got $correctAnswers out of $totalQuestions correct!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Time Taken: ${(totalTime ~/ 60).toString().padLeft(2, '0')}:${(totalTime % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            // Pie chart
            SizedBox(height: 24),
            SizedBox(
              width: 300,
              height: 300,
              child: FlutterPieChart(
                pies: pies,
                 selected: 1,
              ),
            ),
            SizedBox(height: 45),
            ElevatedButton(
              child: Text('Restart Quiz', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => StartQuizPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}