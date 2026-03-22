import 'dart:math';
import '../models/feedback.dart';
import '../models/question.dart';

class ApiService {
  final _random = Random();

  final List<Question> _allQuestions = [
    // Behavioral
    Question(id: 'q1', text: 'Tell me about yourself.', type: 'Behavioral', difficulty: 'Easy', industry: 'General'),
    Question(id: 'q2', text: 'Tell me about a time you faced a difficult challenge at work.', type: 'Behavioral', difficulty: 'Medium', industry: 'General'),
    Question(id: 'q3', text: 'How do you handle conflict in a team setting?', type: 'Behavioral', difficulty: 'Medium', industry: 'General'),
    Question(id: 'q4', text: 'Describe a time you failed and what you learned.', type: 'Behavioral', difficulty: 'Hard', industry: 'General'),
    Question(id: 'q5', text: 'How do you prioritize tasks under tight deadlines?', type: 'Behavioral', difficulty: 'Medium', industry: 'General'),
    
    // Technical
    Question(id: 'q6', text: 'Explain the difference between a stack and a queue.', type: 'Technical', difficulty: 'Easy', industry: 'Software Engineering'),
    Question(id: 'q7', text: 'Describe a system design for a scalable chat application.', type: 'Technical', difficulty: 'Hard', industry: 'Software Engineering'),
    Question(id: 'q8', text: 'What is polymorphism in Object-Oriented Programming?', type: 'Technical', difficulty: 'Medium', industry: 'Software Engineering'),
    Question(id: 'q9', text: 'How do you handle missing values in a dataset?', type: 'Technical', difficulty: 'Medium', industry: 'Data Science'),
    Question(id: 'q10', text: 'Explain A/B testing and p-values.', type: 'Technical', difficulty: 'Hard', industry: 'Data Science'),

    // HR
    Question(id: 'q11', text: 'What is your greatest weakness?', type: 'HR', difficulty: 'Medium', industry: 'General'),
    Question(id: 'q12', text: 'Where do you see yourself in 5 years?', type: 'HR', difficulty: 'Easy', industry: 'General'),
    Question(id: 'q13', text: 'Why is there a gap in your resume?', type: 'HR', difficulty: 'Hard', industry: 'General'),
    Question(id: 'q14', text: 'What are your salary expectations?', type: 'HR', difficulty: 'Medium', industry: 'General'),
    
    // Industry Specific
    Question(id: 'q15', text: 'How do you handle a client who says your software is too expensive?', type: 'Behavioral', difficulty: 'Hard', industry: 'Sales'),
    Question(id: 'q16', text: 'Pitch me this pen.', type: 'Technical', difficulty: 'Medium', industry: 'Sales'),
    Question(id: 'q17', text: 'How do you measure product success?', type: 'Technical', difficulty: 'Medium', industry: 'Product Management'),
  ];

  List<Question> get allQuestions => _allQuestions;

  Future<List<Question>> fetchQuestions(String type, String difficulty, String industry) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Filter questions by type if it matches, otherwise pull related
    List<Question> pool = _allQuestions.where((q) => q.type == type || q.industry == industry).toList();
    if (pool.length < 3) {
      pool = _allQuestions; // fallback
    }
    
    pool.shuffle();
    return pool.take(3).toList();
  }

  Future<InterviewFeedback> analyzeAnswers(Map<String, String> answers) async {
    await Future.delayed(const Duration(seconds: 2));

    double totalRelevancy = 0;
    double totalConfidence = 0;
    double totalConciseness = 0;
    double totalStructure = 0;

    List<String> foundFillerWords = [];
    final fillerWords = ['um', 'like', 'uh', 'you know', 'basically', 'actually', 'literally'];

    for (var answer in answers.values) {
      String text = answer.toLowerCase().trim();
      
      // Calculate Length & Spam Factor
      int wordCount = text.split(' ').where((w) => w.length > 1).length;
      int uniqueWords = text.split(' ').toSet().length;

      double relevancyScore = 15; // default low
      double confidenceScore = 20;
      double structureScore = 10;
      double concisenessScore = 50; // starts high, lowers with rambling
      
      if (text.isEmpty || wordCount < 3) {
        // Zero effort
        relevancyScore = 5;
        structureScore = 5;
        confidenceScore = 10;
      } else if (uniqueWords < wordCount * 0.4) {
        // Spam/gibberish detected (e.g. asd asd asd asd)
        relevancyScore = 5;
        structureScore = 0;
        confidenceScore = 5;
      } else {
        // Legitimate attempt
        relevancyScore = min(98.0, 40.0 + (wordCount * 1.5)); // More words usually means more detail
        
        // Structure based on punctuation and paragraphing
        int sentences = text.split(RegExp(r'[.!?]')).length;
        if (sentences > 2) structureScore = min(95.0, sentences * 25.0);
        
        // Check for filler words and weak phrasing
        for (var filler in fillerWords) {
          if (text.contains(filler)) {
            if (!foundFillerWords.contains(filler)) foundFillerWords.add(filler);
            confidenceScore -= 10;
          }
        }
        
        confidenceScore = max(10.0, min(95.0, confidenceScore + 60.0 + _random.nextInt(15)));
        
        // Relevancy bonus for professional keywords
        if (text.contains('because') || text.contains('resulted') || text.contains('team') || text.contains('led')) {
          relevancyScore += 15;
          structureScore += 15;
        }

        // Penalty for extremely long rambling responses
        if (wordCount > 150) {
          concisenessScore = max(10.0, 90.0 - ((wordCount - 150) * 0.5));
        } else if (wordCount > 30) {
          concisenessScore = 95.0 - _random.nextInt(10);
        }
      }

      totalRelevancy += relevancyScore;
      totalConfidence += confidenceScore;
      totalStructure += structureScore;
      totalConciseness += concisenessScore;
    }

    int qCount = answers.length > 0 ? answers.length : 1;
    
    int relevance = (totalRelevancy / qCount).round().clamp(0, 100);
    int confidence = (totalConfidence / qCount).round().clamp(0, 100);
    int conciseness = (totalConciseness / qCount).round().clamp(0, 100);
    int structure = (totalStructure / qCount).round().clamp(0, 100);

    int overall = ((relevance * 0.6) + (confidence * 0.2) + (conciseness * 0.1) + (structure * 0.1)).round().clamp(0, 100);

    // Dynamic Strengths/Weaknesses
    List<String> strengths = [];
    List<String> weaknesses = [];
    
    if (overall < 20) {
      weaknesses.add('You provided gibberish/empty answers.');
      weaknesses.add('Please take the time to write full sentences.');
    } else {
      if (relevance > 80) strengths.add('Excellent detail and relevancy to the questions.');
      if (structure > 80) strengths.add('Very strong sentence structure and flow.');
      if (confidence > 80) strengths.add('Authoritative tone with minimal filler words.');
      
      if (conciseness < 60) weaknesses.add('Answers were highly repetitive or too lengthy. Be more concise.');
      if (relevance < 50) weaknesses.add('Answers lacked professional context. Try using the STAR method.');
      if (foundFillerWords.isNotEmpty) weaknesses.add('Relied too heavily on filler language.');
      if (strengths.isEmpty) strengths.add('Good attempt, but significant room for improvement.');
    }

    return InterviewFeedback(
      overallScore: overall,
      relevanceScore: relevance,
      confidenceScore: confidence,
      concisenessScore: conciseness,
      structureScore: structure,
      strengths: strengths,
      weaknesses: weaknesses,
      improvedAnswer: overall < 30 ? 'Try answering the question thoughtfully instead of typing random keys.' : 'A better way to approach these answers would clearly outline the STAR method: Situation, Task, Action, Result...',
      fillerWordsDetected: foundFillerWords,
      followUpQuestions: overall > 30 ? [
        'Could you elaborate on the outcome of that situation?',
        'What was the most difficult technical hurdle you faced?'
      ] : ['Can you provide a real answer to the previous question?'],
    );
  }
}
