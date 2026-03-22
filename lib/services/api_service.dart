import 'dart:math';
import '../models/feedback.dart';
import '../models/question.dart';

class ApiService {
  final _random = Random();

  Future<List<Question>> fetchQuestions(String type, String difficulty, String industry) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return [
      Question(
        id: 'q1',
        text: 'Tell me about a time you faced a difficult challenge at work.',
        type: type,
        difficulty: difficulty,
        industry: industry,
      ),
      Question(
        id: 'q2',
        text: 'How do you handle conflict in a team setting?',
        type: type,
        difficulty: difficulty,
        industry: industry,
      ),
      Question(
        id: 'q3',
        text: 'Why do you want to work in the $industry industry?',
        type: type,
        difficulty: difficulty,
        industry: industry,
      ),
    ];
  }

  Future<InterviewFeedback> analyzeAnswers(Map<String, String> answers) async {
    // Simulate API delay for AI processing
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate some random but sensible scores
    int relevance = 50 + _random.nextInt(40);
    int confidence = 50 + _random.nextInt(40);
    int conciseness = 50 + _random.nextInt(40);
    int structure = 50 + _random.nextInt(40);
    
    int overall = ((relevance * 0.6) + (confidence * 0.2) + (conciseness * 0.1) + (structure * 0.1)).round();

    return InterviewFeedback(
      overallScore: overall,
      relevanceScore: relevance,
      confidenceScore: confidence,
      concisenessScore: conciseness,
      structureScore: structure,
      strengths: ['Good personal examples', 'Clear enunciation'],
      weaknesses: ['Sometimes repetitive', 'Rambled on the first question'],
      improvedAnswer: 'A better way to answer Q1 would clearly outline the STAR method: Situation, Task, Action, Result...',
      fillerWordsDetected: ['um', 'like', 'you know'],
      followUpQuestions: [
        'Could you elaborate on the outcome of that challenging project?',
        'How did your team react to your proposed solution?'
      ],
    );
  }
}
