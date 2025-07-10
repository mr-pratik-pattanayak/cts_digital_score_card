import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  String stationName = '';
  String inspectionDate = '';
  String trainNumber = '';
  Map<String, Map<String, dynamic>> coaches = {};


  void updateStationName(String value) {
    stationName = value;
    notifyListeners();
  }

  void updateDate(String value) {
    inspectionDate = value;
    notifyListeners();
  }

  void updateTrainNumber(String value) {
    trainNumber = value;
    notifyListeners();
  }

  void updateCoachScore(String coach, String section, int score) {
    if (!coaches.containsKey(coach)) {
      coaches[coach] = {};
    }
    coaches[coach]![section] = score;
    notifyListeners();
  }

  void addCoach(String coachNumber) {
    if (!coaches.containsKey(coachNumber)) {
      coaches[coachNumber] = {};
      notifyListeners();
    }
  }

  void removeCoach(String coachNumber) {
    if (coaches.containsKey(coachNumber)) {
      coaches.remove(coachNumber);
      notifyListeners();
    }
  }

  void clearForm() {
    stationName = '';
    inspectionDate = '';
    trainNumber = '';
    coaches.clear();
    notifyListeners();
  }
  void updateCoachRemarks(String coach, String section, String remarks) {
    if (!coaches.containsKey(coach)) {
      coaches[coach] = {};
    }
    coaches[coach]![section] = remarks;
    notifyListeners();
  }

}
