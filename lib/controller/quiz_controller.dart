import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:quiz_app/model/question_model.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/screens/welcome_screen.dart';

class QuizController extends GetxController {
  String name = "";
  final List<QuestionModel> _questionList = [
    QuestionModel(
      id: 1,
      question: "What is Flutter primarily used for?",
      answer: 1, // Correct answer: Cross-platform apps
      options: [
        "Web development only",
        "Cross-platform apps",
        "Game development",
        "Desktop software",
      ],
    ),
    QuestionModel(
      id: 2,
      question: "Which programming language is used with Flutter?",
      answer: 0, // Correct answer: Dart
      options: [
        "Dart",
        "Kotlin",
        "Swift",
        "JavaScript",
      ],
    ),
    QuestionModel(
      id: 3,
      question: "What is the widget tree in Flutter?",
      answer: 2, // Correct answer: A hierarchy of widgets
      options: [
        "State management",
        "Animations",
        "Hierarchy of widgets",
        "List of screens",
      ],
    ),
    QuestionModel(
      id: 4,
      question: "Which company developed Flutter?",
      answer: 1, // Correct answer: Google
      options: [
        "Microsoft",
        "Google",
        "Apple",
        "Facebook",
      ],
    ),
    QuestionModel(
      id: 5,
      question: "What is the purpose of the 'build()' method in Flutter?",
      answer: 3, // Correct answer: To describe the UI
      options: [
        "Manage app state",
        "Handle animations",
        "Initialize variables",
        "Describe the UI",
      ],
    ),
    QuestionModel(
      id: 6,
      question: "What is a StatefulWidget in Flutter?",
      answer: 0, // Correct answer: A widget with mutable state
      options: [
        "Widget with mutable state",
        "Widget without state",
        "Manages routing",
        "Handles gestures",
      ],
    ),
    QuestionModel(
      id: 7,
      question: "What does the 'setState()' method do in Flutter?",
      answer: 2, // Correct answer: Updates UI on state change
      options: [
        "Navigate to a new screen",
        "Initialize widget state",
        "Update UI on state change",
        "Destroy the widget",
      ],
    ),
    QuestionModel(
      id: 8,
      question: "Which of the following is a key feature of Flutter?",
      answer: 1, // Correct answer: Hot Reload
      options: [
        "MVC Architecture",
        "Hot Reload",
        "Auto DB Sync",
        "Native Compilation",
      ],
    ),
    QuestionModel(
      id: 9,
      question: "Which widget creates scrollable content in Flutter?",
      answer: 3, // Correct answer: ListView
      options: [
        "Container",
        "Stack",
        "Column",
        "ListView",
      ],
    ),
    QuestionModel(
      id: 10,
      question: "Which file is the entry point of a Flutter app?",
      answer: 0, // Correct answer: main.dart
      options: [
        "main.dart",
        "index.html",
        "app.dart",
        "start.dart",
      ],
    ),
  ];
  bool _isPressed = false;
  double _numberOfQuestions = 1;
  int? _selectedAnswer;
  int _countOfCorrectAnswers = 0;
  final RxInt _sec = 15.obs;
  int get contOfQuestions => _questionList.length;
  List<QuestionModel> get questionList => [..._questionList];
  bool get isPressed => _isPressed;
  double get numberOfQuestions => _numberOfQuestions;
  int? get selectedAnswer => _selectedAnswer;
  int get countOfCorrectAnswers => _countOfCorrectAnswers;
  RxInt get sec => _sec;
  int? _correctAnswer;
  final Map<int, bool> __questionIsAnswered = {};
  Timer? _timer;
  final maxSec = 15;
  late PageController pageController;
  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    resetAnswers();
    super.onInit();
  }

  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  double get scoreResult {
    return countOfCorrectAnswers * 100 / _questionList.length;
  }

  void checkAnswer(QuestionModel questioModel, int selectedAnswer) {
    _isPressed = true;
    _selectedAnswer = selectedAnswer;
    _correctAnswer = questioModel.answer;
    if (_correctAnswer == _selectedAnswer) {
      _countOfCorrectAnswers++;
    }
    stopTimer();

    __questionIsAnswered.update(questioModel.id, (value) => true);
    Future.delayed(const Duration(milliseconds: 500))
        .then((Value) => nextQuestion());
    update();
  }

  bool checkIsQuestionAnswered(int questionId) {
    return __questionIsAnswered.entries
        .firstWhere((element) => element.key == questionId)
        .value;
  }

  void resetAnswers() {
    for (var element in _questionList) {
      __questionIsAnswered.addAll({element.id: false});
    }
    update();
  }

  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green;
      } else if (answerIndex == _selectedAnswer &&
          _correctAnswer != _selectedAnswer) {
        return Colors.red;
      }
    }
    return Colors.white;
  }

  IconData getIcon(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectedAnswer &&
          _correctAnswer != _selectedAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sec.value > 0) {
        _sec.value--;
      } else {
        stopTimer();
        nextQuestion();
      }
    });
  }

  void resetTimer() => _sec.value = maxSec;
  void stopTimer() => _timer!.cancel();

  nextQuestion() {
    if (_timer != null || _timer!.isActive) {
      stopTimer();
    }
    if (pageController.page == _questionList.length - 1) {
      Get.offAndToNamed(ResultScreen.routeName);
    } else {
      _isPressed = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
      startTimer();
    }
    _numberOfQuestions = pageController.page! + 2;
  }

  void startAgain() {
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    _selectedAnswer = null;
    resetAnswers();
    Get.offAllNamed(WelcomeScreen.routeName);
  }
}
