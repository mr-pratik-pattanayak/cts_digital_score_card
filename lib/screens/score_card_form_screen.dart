import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/form_provider.dart';
import '../services/api_service.dart';
import '../widgets/score_input_widget.dart';
import 'summary_screen.dart';

class ScoreCardFormScreen extends StatefulWidget {
  const ScoreCardFormScreen({super.key});

  @override
  State<ScoreCardFormScreen> createState() => _ScoreCardFormScreenState();
}

class _ScoreCardFormScreenState extends State<ScoreCardFormScreen> {
  final stationController = TextEditingController();
  final trainController = TextEditingController();
  final dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    stationController.dispose();
    trainController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _showValidationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF8F8F8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: const [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Incomplete Form'),
          ],
        ),
        content: const Text(
          'Please fill all required fields and ensure they are in the correct format before proceeding.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CTS Score Card'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: stationController,
                decoration: const InputDecoration(
                  labelText: 'Station Name',
                  border: OutlineInputBorder(),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: formProvider.updateStationName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter station name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: trainController,
                decoration: const InputDecoration(
                  labelText: 'Train Number',
                  border: OutlineInputBorder(),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                keyboardType: TextInputType.number,
                onChanged: formProvider.updateTrainNumber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter train number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Train number must be numeric';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Inspection Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: formProvider.updateDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date';
                  }
                  final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!regex.hasMatch(value)) {
                    return 'Date must be in YYYY-MM-DD format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Divider(),

              ...formProvider.coaches.keys.map((coach) {
                return Card(
                  color: const Color(0xFFA175EF),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Coach: $coach',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            IconButton(
                              icon:
                              const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                formProvider.removeCoach(coach);
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 18),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA0C7F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ...['T1', 'T2', 'D1', 'D2'].map((section) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF8FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin:
                                  const EdgeInsets.symmetric(vertical: 6),
                                  padding: const EdgeInsets.all(8),
                                  child: ScoreInputWidget(
                                      coach: coach, section: section),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              }).toList(),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    String newCoachNumber =
                        'C${formProvider.coaches.length + 1}';
                    formProvider.addCoach(newCoachNumber);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Coach'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SummaryScreen()),
                      );
                    } else {
                      _showValidationPopup(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                  ),
                  child: const Text('Review Summary',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    formProvider.clearForm();
                    stationController.clear();
                    trainController.clear();
                    dateController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form Cleared!')),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Clear Form'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
