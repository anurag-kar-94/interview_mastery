import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import 'interview_screen.dart';

class InterviewSetupScreen extends StatefulWidget {
  const InterviewSetupScreen({Key? key}) : super(key: key);

  @override
  State<InterviewSetupScreen> createState() => _InterviewSetupScreenState();
}

class _InterviewSetupScreenState extends State<InterviewSetupScreen> {
  String _selectedType = 'Behavioral';
  String _selectedDifficulty = 'Medium';
  String _selectedIndustry = 'Software Engineering';

  final _types = ['Behavioral', 'Technical', 'HR'];
  final _difficulties = ['Easy', 'Medium', 'Hard'];
  final _industries = ['Software Engineering', 'Product Management', 'Data Science', 'Sales'];

  void _startInterview() async {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    await provider.startNewInterview(_selectedType, _selectedDifficulty, _selectedIndustry);
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InterviewScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AppStateProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Interview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Customize your practice session',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            _buildDropdown('Interview Type', _selectedType, _types, (val) {
              setState(() => _selectedType = val!);
            }),
            const SizedBox(height: 16),
            _buildDropdown('Difficulty', _selectedDifficulty, _difficulties, (val) {
              setState(() => _selectedDifficulty = val!);
            }),
            const SizedBox(height: 16),
            _buildDropdown('Industry', _selectedIndustry, _industries, (val) {
              setState(() => _selectedIndustry = val!);
            }),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: isLoading ? null : _startInterview,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Start Interview', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
