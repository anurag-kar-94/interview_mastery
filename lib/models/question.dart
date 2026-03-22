class Question {
  final String id;
  final String text;
  final String type; // Behavioral, Technical, HR
  final String difficulty; // Easy, Medium, Hard
  final String industry; // Software, General, Sales, etc.

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.difficulty,
    required this.industry,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      type: json['type'],
      difficulty: json['difficulty'],
      industry: json['industry'],
    );
  }
}
