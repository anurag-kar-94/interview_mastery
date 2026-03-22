import 'package:flutter/material.dart';
import '../models/interview.dart';

class AiFeedbackScreen extends StatelessWidget {
  final Interview interview;

  const AiFeedbackScreen({Key? key, required this.interview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedback = interview.feedback;

    if (feedback == null) {
      return const Scaffold(body: Center(child: Text('Feedback generation failed.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOverallScoreCard(context, feedback.overallScore),
            const SizedBox(height: 24),
            _buildScoreBreakdown(context, feedback),
            const SizedBox(height: 24),
            _buildSection(context, 'Strengths', feedback.strengths, Icons.thumb_up, Colors.green),
            const SizedBox(height: 16),
            _buildSection(context, 'Areas to Improve', feedback.weaknesses, Icons.lightbulb, Colors.orange),
            const SizedBox(height: 16),
            _buildFollowUps(context, feedback.followUpQuestions),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Dashboard'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard(BuildContext context, int score) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Overall Assessment', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.white30,
                    color: score >= 80 ? Colors.green : (score >= 60 ? Colors.orange : Colors.red),
                  ),
                ),
                Text('$score%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBreakdown(BuildContext context, dynamic feedback) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score Breakdown', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildScoreBar('Relevance (60%)', feedback.relevanceScore, Colors.blue),
            _buildScoreBar('Confidence (20%)', feedback.confidenceScore, Colors.purple),
            _buildScoreBar('Conciseness (10%)', feedback.concisenessScore, Colors.teal),
            _buildScoreBar('Structure (10%)', feedback.structureScore, Colors.indigo),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('$value%'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / 100,
            color: color,
            backgroundColor: color.withOpacity(0.2),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> items, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUps(BuildContext context, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.question_answer, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('Suggested Follow-ups', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('- "$item"', style: const TextStyle(fontStyle: FontStyle.italic)),
            )),
          ],
        ),
      ),
    );
  }
}
