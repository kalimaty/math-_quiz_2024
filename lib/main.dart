import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Quiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizState = Provider.of<QuizState>(context);

    if (quizState.gameEnded) {
      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              correctCount: quizState.correctCount,
              wrongCount: quizState.wrongCount,
              totalTimeTaken: quizState.totalTimeTaken,
              totalAllocatedTime:
                  quizState.totalQuestions * quizState.timePerQuestion,
              timeTakenPerQuestion: quizState.timeTakenPerQuestion,
              onReset: () {
                quizState.resetGame();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 200, 250),
        title: const Text('Math question'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(quizState.question, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: const Color.fromARGB(255, 20, 200, 250),
                          elevation: 10,
                          child: ListTile(
                            leading: const Icon(
                              Icons.question_answer,
                              color: Colors.white,
                            ),
                            trailing: Text(
                              "${index + 1} ) ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                            title: Text(
                              quizState.answers[index].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      quizState.checkAnswer(quizState.answers[index]);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                margin: const EdgeInsets.all(30),
                color: const Color.fromARGB(255, 20, 200, 250),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.width * 0.20,
                          child: SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              size: MediaQuery.of(context).size.width * 0.20,
                              customColors: CustomSliderColors(
                                trackColor: Colors.black38,
                                progressBarColor: Colors.white,
                                dotColor: Colors.amber,
                                shadowColor: Colors.blueAccent.shade100,
                              ),
                              startAngle: 270,
                              angleRange: 360,
                              customWidths: CustomSliderWidths(
                                trackWidth: 10,
                                progressBarWidth: 10,
                                handlerSize: 7,
                              ),
                            ),
                            min: 0,
                            max: quizState.timePerQuestion.toDouble(),
                            initialValue: quizState.timeLeft.toDouble(),
                            innerWidget: (percentage) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${quizState.timeLeft}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final int correctCount;
  final int wrongCount;
  final int totalTimeTaken;
  final int totalAllocatedTime;
  final List<int> timeTakenPerQuestion;
  final VoidCallback onReset;

  const ResultsPage({
    Key? key,
    required this.correctCount,
    required this.wrongCount,
    required this.totalTimeTaken,
    required this.timeTakenPerQuestion,
    required this.totalAllocatedTime,
    required this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Results'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(width: 2, color: Colors.blue),
                  children: [
                    TableRow(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 159, 243, 163)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Statistic',
                                style: const TextStyle(fontSize: 20)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Value',
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 202, 255)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Correct Answers',
                                style: const TextStyle(fontSize: 20)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$correctCount',
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 202, 255)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Wrong Answers',
                                style: const TextStyle(fontSize: 20)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$wrongCount',
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 202, 255)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Total Time Taken',
                                style: const TextStyle(fontSize: 20)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$totalTimeTaken seconds',
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 202, 255)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Total Allocated Time',
                                style: const TextStyle(fontSize: 20)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$totalAllocatedTime seconds',
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Time Taken Per Question:',
                  style: const TextStyle(fontSize: 20)),
              Table(
                border: TableBorder.all(width: 2, color: Colors.blue),
                children: List.generate(timeTakenPerQuestion.length, (index) {
                  return TableRow(
                      decoration: BoxDecoration(color: Colors.amber.shade100),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Question ${index + 1}',
                              style: const TextStyle(fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${timeTakenPerQuestion[index]} seconds',
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ]);
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onReset,
                child: const Text('Reset', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizState with ChangeNotifier {
  final int totalQuestions = 5;
  final int timePerQuestion = 10; // seconds per question
  List<int> timeTakenPerQuestion = [];

  late String _question;
  late List<int> _answers;
  late int _correctAnswer;
  int _correctCount = 0;
  int _wrongCount = 0;
  int _currentQuestionIndex = 0;
  int _totalTimeTaken = 0;
  int _timeLeft = 0;
  Timer? _timer;
  bool _gameEnded = false;

  QuizState() {
    _startGame();
  }

  String get question => _question;
  List<int> get answers => _answers;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;
  int get totalTimeTaken => _totalTimeTaken;
  int get timeLeft => _timeLeft;
  bool get gameEnded => _gameEnded;

  void _startGame() {
    _currentQuestionIndex = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _totalTimeTaken = 0;
    timeTakenPerQuestion = [];
    _gameEnded = false;
    _loadNextQuestion();
  }

  void _loadNextQuestion() {
    if (_currentQuestionIndex >= totalQuestions) {
      _endGame();
      return;
    }
    _generateQuestion();
    _timeLeft = timePerQuestion;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        _wrongCount++;
        timeTakenPerQuestion.add(timePerQuestion);
        _totalTimeTaken += timePerQuestion;
        _currentQuestionIndex++;
        _loadNextQuestion();
      }
    });
    notifyListeners();
  }

  void _generateQuestion() {
    final math.Random random = math.Random();
    int a = random.nextInt(10) + 1;
    int b = random.nextInt(10) + 1;
    _question = '$a + $b = ?';
    _correctAnswer = a + b;
    _answers = [_correctAnswer];
    while (_answers.length < 4) {
      int wrongAnswer =
          random.nextInt(19) + 1; // possible range of wrong answers
      if (!_answers.contains(wrongAnswer)) {
        _answers.add(wrongAnswer);
      }
    }
    _answers.shuffle();
  }

  void checkAnswer(int answer) {
    _timer?.cancel();
    if (answer == _correctAnswer) {
      _correctCount++;
      timeTakenPerQuestion.add(timePerQuestion - _timeLeft);
      _totalTimeTaken += (timePerQuestion - _timeLeft);
    } else {
      _wrongCount++;
      timeTakenPerQuestion.add(timePerQuestion);
      _totalTimeTaken += timePerQuestion;
    }
    _currentQuestionIndex++;
    _loadNextQuestion();
    notifyListeners();
  }

  void _endGame() {
    _gameEnded = true;
    _timer?.cancel();
    notifyListeners();
  }

  void resetGame() {
    _startGame();
    notifyListeners();
  }
}
