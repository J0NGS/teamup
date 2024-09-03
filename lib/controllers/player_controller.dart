import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  var name = ''.obs;
  var selectedPosition = 'Atacante'.obs;
  var skillRating = 0.obs;
  var speed = 1.obs;
  var phase = 1.obs;
  var movement = 1.obs;
  var photoUrl = ''.obs;

  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      name.value = nameController.text;
    });
  }

  void setName(String value) {
    name.value = value;
    nameController.text = value;
  }

  void setSelectedPosition(String value) => selectedPosition.value = value;
  void setSkillRating(int value) => skillRating.value = value;
  void setSpeed(int value) => speed.value = value;
  void setPhase(int value) => phase.value = value;
  void setMovement(int value) => movement.value = value;
  void setPhotoUrl(String value) => photoUrl.value = value;
}