import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/form_provider.dart';

class ScoreInputWidget extends StatefulWidget {
  final String coach;
  final String section;

  const ScoreInputWidget({super.key, required this.coach, required this.section});

  @override
  State<ScoreInputWidget> createState() => _ScoreInputWidgetState();
}

class _ScoreInputWidgetState extends State<ScoreInputWidget> {
  final TextEditingController remarkController = TextEditingController();

  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.coach} - ${widget.section}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Score: '),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: formProvider.coaches[widget.coach]?[widget.section] ?? 1,
                  items: List.generate(10, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      formProvider.updateCoachScore(widget.coach, widget.section, value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: remarkController,
              decoration: InputDecoration(
                labelText: 'Remarks (optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onChanged: (value) {
                formProvider.updateCoachRemarks(widget.coach, '${widget.section}_remarks', value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
