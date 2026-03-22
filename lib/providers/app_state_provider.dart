import 'package:flutter/material.dart';
import '../models/interview.dart';
import '../models/question.dart';
import '../services/api_service.dart';

class AppStateProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Interview> _interviewHistory = [];
  List<Interview> get interviewHistory => _interviewHistory;

  Interview? _currentInterview;
  Interview? get currentInterview => _currentInterview;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> startNewInterview(String type, String difficulty, String industry) async {
    _isLoading = true;
    notifyListeners();

    try {
      final questions = await _apiService.fetchQuestions(type, difficulty, industry);
      _currentInterview = Interview(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        difficulty: difficulty,
        industry: industry,
        date: DateTime.now(),
        questions: questions,
      );
    } catch (e) {
      debugPrint('Error starting interview: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateAnswer(String questionId, String answerText) {
    if (_currentInterview != null) {
      final updatedAnswers = Map<String, String>.from(_currentInterview!.answers);
      updatedAnswers[questionId] = answerText;
      _currentInterview = _currentInterview!.copyWith(answers: updatedAnswers);
      notifyListeners();
    }
  }

  Future<void> submitInterview() async {
    if (_currentInterview == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final feedback = await _apiService.analyzeAnswers(_currentInterview!.answers);
      _currentInterview = _currentInterview!.copyWith(feedback: feedback);
      _interviewHistory.insert(0, _currentInterview!);
      _currentInterview = null; // Clear active interview
    } catch (e) {
      debugPrint('Error analyzing interview: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
