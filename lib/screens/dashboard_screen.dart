import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import 'interview_setup_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          final history = provider.interviewHistory;
          
          int totalInterviews = history.length;
          double avgScore = 0;
          if (history.isNotEmpty) {
            avgScore = history.fold(0.0, (sum, item) => sum + (item.feedback?.overallScore ?? 0)) / totalInterviews;
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildStartInterviewCard(context),
              const SizedBox(height: 24),
              Text(
                'Performance Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, 'Total Interviews', totalInterviews.toString(), Icons.history)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, 'Average Score', '${avgScore.toStringAsFixed(1)}%', Icons.score)),
                ],
              ),
              const SizedBox(height: 16),
              _buildWeakAreasCard(context, history),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStartInterviewCard(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.rocket_launch, size: 48),
            const SizedBox(height: 16),
            Text(
              'Ready for your next interview?',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InterviewSetupScreen()),
                );
              },
              child: const Text('Start New Interview'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildWeakAreasCard(BuildContext context, List history) {
    // Mock weak areas
    final weakAreas = ['Conciseness', 'Handling technical questions', 'Filler words'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_down, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 8),
                Text('Areas to Improve', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            ...weakAreas.map((area) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8),
                  const SizedBox(width: 8),
                  Text(area),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
