import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';

class GroupController extends GetxController {
  var groups = <Group>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    List<dynamic>? storedGroups = box.read<List<dynamic>>('grupos');
    if (storedGroups != null) {
      groups.assignAll(storedGroups.map((group) => Group(
        name: group['name'],
        players: List<Player>.from(group['players'].map((player) => Player(
          name: player['name'],
          position: player['position'],
          skillRating: player['skillRating'],
          speed: player['speed'],
          phase: player['phase'],
          movement: player['movement'],
          photoUrl: player['photoUrl'],
        ))),
      )));
    }
  }

  void addGroup(Group group) {
    groups.add(group);
    _saveToStorage();
  }

  void removeGroup(Group group) {
    groups.remove(group);
    _saveToStorage();
  }

  void addPlayerToGroup(Group group, Player player) {
    group.players.add(player);
    _saveToStorage();
  }

  void _saveToStorage() {
    box.write('grupos', groups.map((g) => {
      'name': g.name,
      'players': g.players.map((p) => {
        'name': p.name,
        'position': p.position,
        'skillRating': p.skillRating,
        'speed': p.speed,
        'phase': p.phase,
        'movement': p.movement,
        'photoUrl': p.photoUrl,
      }).toList(),
    }).toList());
  }
}
