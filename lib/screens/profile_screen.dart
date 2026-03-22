import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import 'package:intl/intl.dart';
import 'ai_feedback_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final history = context.watch<AppStateProvider>().interviewHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            'john.doe@example.com',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            'Interview History',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (history.isEmpty)
            const Center(child: Text('No interviews completed yet.'))
          else
            ...history.map((interview) => Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                title: Text('${interview.industry} • ${interview.type}'),
                subtitle: Text(DateFormat.yMMMd().format(interview.date)),
                trailing: Text(
                  '${interview.feedback?.overallScore ?? 0}%',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AiFeedbackScreen(interview: interview),
                    ),
                  );
                },
              ),
            )),
        ],
      ),
    );
  }
}
