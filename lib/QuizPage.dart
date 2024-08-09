import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'ResultPage.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  List<int> userAnswers = [];
  late Timer _timer;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    loadQuizData();
    startTimer();
  }

  int get correctAnswers => userAnswers.asMap().entries
      .where((entry) => entry.value == questions[entry.key]['correctAnswer'])
      .length;

  void loadQuizData() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/quiz_data.json");
    var jsonResult = json.decode(data);
    setState(() {
      questions = List<Map<String, dynamic>>.from(jsonResult['questions']);
      userAnswers = List<int>.filled(questions.length, -1);
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _totalSeconds++;
      });
    });
  }

  void answerQuestion(int selectedIndex) {
    if (userAnswers[currentQuestionIndex] == -1) {
      setState(() {
        userAnswers[currentQuestionIndex] = selectedIndex;
      });
    }
  }

  void nextQuestion() {
    if (userAnswers[currentQuestionIndex] == -1) return;
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      submitQuiz();
    }
  }

  void submitQuiz() {
    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultPage(correctAnswers: correctAnswers, questions: questions, totalTime: _totalSeconds)),
    );
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    var currentQuestion = questions[currentQuestionIndex];
    bool isFirstQuestion = currentQuestionIndex == 0;
    bool isLastQuestion = currentQuestionIndex == questions.length - 1;
    bool isAnswerSelected = userAnswers[currentQuestionIndex] != -1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestionIndex + 1}/${questions.length}  '),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Correctly answered: ${correctAnswers}'),
              SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        currentQuestion['question'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    currentQuestion['options'].length,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            currentQuestion['options'][index],
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAnswerSelected
                                ? (index == currentQuestion['correctAnswer']
                                ? Colors.green
                                : (index == userAnswers[currentQuestionIndex]
                                ? Colors.red
                                : null))
                                : null,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () => answerQuestion(index),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!isFirstQuestion)
                      ElevatedButton(
                        child: Text('Previous'),
                        onPressed: previousQuestion,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ElevatedButton(
                      child: Text(isLastQuestion ? 'Finish' : 'Next'),
                      onPressed: isAnswerSelected ? nextQuestion : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}