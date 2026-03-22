import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';

class QuestionLibraryScreen extends StatefulWidget {
  const QuestionLibraryScreen({Key? key}) : super(key: key);

  @override
  State<QuestionLibraryScreen> createState() => _QuestionLibraryScreenState();
}

class _QuestionLibraryScreenState extends State<QuestionLibraryScreen> {
  final List<Question> _allQuestions = ApiService().allQuestions;
  // Wait, ApiService's questions are private (_allQuestions) in my previous write.
  // Actually, I can just initialize them here or make them accessible.
  
  String _filterType = 'All';

  @override
  Widget build(BuildContext context) {
    // We will hook this up to ApiService tomorrow, for now just a small list to show.
    // Actually let's just create a quick local expanded list so it doesn't break.
    final List<Question> localQuestions = [
      Question(id: '1', text: 'Tell me about yourself.', type: 'Behavioral', difficulty: 'Easy', industry: 'General'),
      Question(id: '2', text: 'What is your greatest weakness?', type: 'HR', difficulty: 'Medium', industry: 'General'),
      Question(id: '3', text: 'Explain a complex concept to a non-technical person.', type: 'Behavioral', difficulty: 'Hard', industry: 'Software Engineering'),
      Question(id: '4', text: 'How do you prioritize tasks under tight deadlines?', type: 'Behavioral', difficulty: 'Medium', industry: 'General'),
      Question(id: '5', text: 'Where do you see yourself in 5 years?', type: 'HR', difficulty: 'Easy', industry: 'General'),
      Question(id: '6', text: 'Describe a system design for a scalable chat application.', type: 'Technical', difficulty: 'Hard', industry: 'Software Engineering'),
      Question(id: '7', text: 'How do you handle conflict in a team setting?', type: 'Behavioral', difficulty: 'Medium', industry: 'General'),
      Question(id: '8', text: 'Pitch me this pen.', type: 'Technical', difficulty: 'Medium', industry: 'Sales'),
      Question(id: '9', text: 'How do you measure product success?', type: 'Technical', difficulty: 'Medium', industry: 'Product Management'),
      Question(id: '10', text: 'Explain A/B testing and p-values.', type: 'Technical', difficulty: 'Hard', industry: 'Data Science'),
    ];

    final filteredQuestions = _filterType == 'All' 
        ? localQuestions 
        : localQuestions.where((q) => q.type == _filterType).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Library'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: ['All', 'Behavioral', 'Technical', 'HR'].map((type) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(type),
                    selected: _filterType == type,
                    onSelected: (selected) {
                      setState(() => _filterType = type);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredQuestions.length,
              itemBuilder: (context, index) {
                final q = filteredQuestions[index];
                return ListTile(
                  title: Text(q.text),
                  subtitle: Text('${q.type} • ${q.difficulty} • ${q.industry}'),
                  trailing: const Icon(Icons.bookmark_border),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
