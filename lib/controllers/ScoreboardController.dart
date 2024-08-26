import 'dart:async';

import 'package:get/get.dart';

class ScoreboardController extends GetxController {
  var scoreTeam1 = 0.obs;
  var scoreTeam2 = 0.obs;
  var remainingTime = 0.obs;
  late Timer _timer;

  void startTimer(int totalSeconds) {
    remainingTime.value = totalSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        _timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void incrementScoreTeam1() {
    scoreTeam1.value++;
  }

  void decrementScoreTeam1() {
    if (scoreTeam1.value > 0) scoreTeam1.value--;
  }

  void incrementScoreTeam2() {
    scoreTeam2.value++;
  }

  void decrementScoreTeam2() {
    if (scoreTeam2.value > 0) scoreTeam2.value--;
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}