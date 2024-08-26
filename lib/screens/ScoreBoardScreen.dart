import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/utils/colors.dart';

import '../controllers/ScoreboardController.dart';

class ScoreboardScreen extends StatelessWidget {
  final int timer;
  ScoreboardScreen({required this.timer});

  @override
  Widget build(BuildContext context) {
    final ScoreboardController controller = Get.put(ScoreboardController());
    controller.startTimer(timer);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Placar', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.green),
        backgroundColor: Black100,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.incrementScoreTeam1,
              onDoubleTap: controller.decrementScoreTeam1,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Obx(() => Text(
                    '${controller.scoreTeam1.value}',
                    style: const TextStyle(color: Colors.white, fontSize: 100),
                  )),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            height: 100,
            child: Center(
              child: Obx(() => Text(
                '${controller.remainingTime.value}',
                style: const TextStyle(color: Colors.white, fontSize: 50),
              )),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: controller.incrementScoreTeam2,
              onDoubleTap: controller.decrementScoreTeam2,
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Obx(() => Text(
                    '${controller.scoreTeam2.value}',
                    style: const TextStyle(color: Colors.white, fontSize: 100),
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: BackgroundBlack,
    );
  }
}