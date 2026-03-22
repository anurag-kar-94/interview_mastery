import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import 'ai_feedback_screen.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({Key? key}) : super(key: key);

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  int _currentQuestionIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  int _timeLeft = 120; // 2 minutes per question
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        // Time's up, auto-submit or prompt
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  void _nextQuestion(AppStateProvider provider) {
    if (provider.currentInterview == null) return;
    final questions = provider.currentInterview!.questions;
    final currentQ = questions[_currentQuestionIndex];

    provider.updateAnswer(currentQ.id, _answerController.text);

    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.clear();
      });
      _startTimer();
    } else {
      _finishInterview(provider);
    }
  }

  Future<void> _finishInterview(AppStateProvider provider) async {
    _timer?.cancel();
    await provider.submitInterview();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AiFeedbackScreen(
            interview: provider.interviewHistory.first,
          ),
        ),
      );
    }
  }

  void _simulateVoiceInput() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Listening... (Simulated voice input)')),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _answerController.text = "Here is my simulated response to this question. I used the STAR method to structure my answer.";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final currentInterview = provider.currentInterview;

    if (currentInterview == null) {
      return const Scaffold(body: Center(child: Text('No active interview')));
    }

    final questions = currentInterview.questions;
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: Text('Error: No questions found')));
    }

    final question = questions[_currentQuestionIndex];
    final isLast = _currentQuestionIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1} of ${questions.length}'),
        automaticallyImplyLeading: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${(_timeLeft ~/ 60).toString().padLeft(2, '0')}:${(_timeLeft % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _timeLeft < 30 ? Colors.red : null,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: TextField(
                controller: _answerController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Type your answer here, or use voice input...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.extended(
                  onPressed: _simulateVoiceInput,
                  icon: const Icon(Icons.mic),
                  label: const Text('Dictate'),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: provider.isLoading ? null : () => _nextQuestion(provider),
                  child: provider.isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(isLast ? 'Submit Interview' : 'Next Question'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
