import 'package:get_storage/get_storage.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';

class GroupStorageService {
  final box = GetStorage();

  List<Group> readGroups() {
    List<dynamic>? storedGroups = box.read<List<dynamic>>('grupos');
    if (storedGroups != null) {
      return storedGroups.map((group) {
        return Group(
          id: group['id'] ?? '', // Verifica se o id não é nulo
          name: group['name'] ?? 'Unnamed Group', // Verifica se o nome não é nulo
          players: List<Player>.from(group['players']?.map((player) {
            return Player(
              id: player['id'] ?? '', // Verifica se o id não é nulo
              name: player['name'] ?? 'Unnamed Player', // Verifica se o nome não é nulo
              position: player['position'] ?? 'Unknown', // Verifica se a posição não é nula
              skillRating: player['skillRating'] ?? 0, // Verifica se a nota de habilidade não é nula
              speed: player['speed'] ?? 1, // Verifica se a velocidade não é nula
              phase: player['phase'] ?? 1, // Verifica se a fase não é nula
              movement: player['movement'] ?? 1, // Verifica se a movimentação não é nula
              photoUrl: player['photoUrl'] ?? '', // Verifica se a URL da foto não é nula
              isChecked: player['isChecked'] ?? false, // Verifica se o estado de verificação não é nulo
            );
          }) ?? []), // Garante que a lista de jogadores não seja nula
        );
      }).toList();
    }
    return [];
  }

  void writeGroups(List<Group> groups) {
    box.write('grupos', groups.map((g) => {
      'id': g.id,
      'name': g.name,
      'players': g.players.map((p) => {
        'id': p.id,
        'name': p.name,
        'position': p.position,
        'skillRating': p.skillRating,
        'speed': p.speed,
        'phase': p.phase,
        'movement': p.movement,
        'photoUrl': p.photoUrl,
        'isChecked': p.isChecked,
      }).toList(),
    }).toList());
  }
}