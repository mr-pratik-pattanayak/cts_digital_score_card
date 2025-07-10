import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/form_provider.dart';

class ApiService {
  static Future<void> submitScoreCard(FormProvider formProvider) async {
    final url = Uri.parse('https://httpbin.org/post'); // or webhook.site
    final payload = {
      'stationName': formProvider.stationName,
      'inspectionDate': formProvider.inspectionDate,
      'trainNumber': formProvider.trainNumber,
      'coaches': formProvider.coaches,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print('Submission successful: ${response.body}');
    } else {
      print('Submission failed');
    }
  }
}
