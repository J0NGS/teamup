import 'package:get/get.dart';

class Player {
  var id = ''.obs;
  var name = ''.obs;
  var position = ''.obs;
  var skillRating = 0.obs;
  var speed = 1.obs;
  var phase = 1.obs;
  var movement = 1.obs;
  var photoUrl = ''.obs;
  var isChecked = false.obs;
  var groupId = ''.obs;

  Player({
    required String id,
    required String name,
    required String position,
    required int skillRating,
    required int speed,
    required int phase,
    required int movement,
    required String photoUrl,
    required bool isChecked,
    required String groupId,
  }) {
    this.id.value = id;
    this.name.value = name;
    this.position.value = position;
    this.skillRating.value = skillRating;
    this.speed.value = speed;
    this.phase.value = phase;
    this.movement.value = movement;
    this.photoUrl.value = photoUrl;
    this.isChecked.value = isChecked;
    this.groupId.value = groupId;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.value,
      'name': name.value,
      'position': position.value,
      'skillRating': skillRating.value,
      'speed': speed.value,
      'phase': phase.value,
      'movement': movement.value,
      'photoUrl': photoUrl.value,
      'isChecked': isChecked.value ? 1 : 0,
      'groupId': groupId.value,
    };
  }

  static Player fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      skillRating: map['skillRating'],
      speed: map['speed'],
      phase: map['phase'],
      movement: map['movement'],
      photoUrl: map['photoUrl'],
      isChecked: map['isChecked'] == 1,
      groupId: map['groupId'],
    );
  }
}
