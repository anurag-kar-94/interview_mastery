class InterviewFeedback {
  final int overallScore; // 0-100
  final int relevanceScore; // 60% weight
  final int confidenceScore; // 20% weight
  final int concisenessScore; // 10% weight
  final int structureScore; // 10% weight
  final List<String> strengths;
  final List<String> weaknesses;
  final String improvedAnswer;
  final List<String> fillerWordsDetected;
  final List<String> followUpQuestions;

  InterviewFeedback({
    required this.overallScore,
    required this.relevanceScore,
    required this.confidenceScore,
    required this.concisenessScore,
    required this.structureScore,
    required this.strengths,
    required this.weaknesses,
    required this.improvedAnswer,
    required this.fillerWordsDetected,
    required this.followUpQuestions,
  });
}
