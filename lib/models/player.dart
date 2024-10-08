import 'package:get/get.dart';

class Player {
  String id;
  String name;
  String position;
  int skillRating;
  int speed;
  int phase;
  int movement;
  String photoUrl;
  bool isChecked;
  String groupId;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.skillRating,
    required this.speed,
    required this.phase,
    required this.movement,
    required this.photoUrl,
    required this.isChecked,
    required this.groupId,
  }) {
    this.id = id;
    this.name = name;
    this.position = position;
    this.skillRating = skillRating;
    this.speed = speed;
    this.phase = phase;
    this.movement = movement;
    this.photoUrl = photoUrl;
    this.isChecked = isChecked;
    this.groupId = groupId;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'skillRating': skillRating,
      'speed': speed,
      'phase': phase,
      'movement': movement,
      'photoUrl': photoUrl,
      'isChecked': isChecked ? 1 : 0,
      'groupId': groupId,
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
