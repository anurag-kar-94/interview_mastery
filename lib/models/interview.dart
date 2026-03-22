import 'question.dart';
import 'feedback.dart';

class Interview {
  final String id;
  final String type;
  final String difficulty;
  final String industry;
  final DateTime date;
  final List<Question> questions;
  final Map<String, String> answers; // questionId -> text answer
  InterviewFeedback? feedback;

  Interview({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.industry,
    required this.date,
    required this.questions,
    this.answers = const {},
    this.feedback,
  });

  Interview copyWith({
    Map<String, String>? answers,
    InterviewFeedback? feedback,
  }) {
    return Interview(
      id: id,
      type: type,
      difficulty: difficulty,
      industry: industry,
      date: date,
      questions: questions,
      answers: answers ?? this.answers,
      feedback: feedback ?? this.feedback,
    );
  }
}
