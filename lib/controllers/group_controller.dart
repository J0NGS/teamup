import 'package:get/get.dart';  // Importa o pacote GetX, que é utilizado para gerenciamento de estado e dependências
import 'package:get_storage/get_storage.dart';  // Importa o pacote GetStorage, utilizado para persistência de dados localmente
import 'package:teamup/models/group.dart';  // Importa o modelo Group, que representa um grupo de jogadores
import 'package:teamup/models/player.dart';  // Importa o modelo Player, que representa um jogador

// Define o controlador que gerencia a lista de grupos e a persistência de dados
class GroupController extends GetxController {
  var groups = <Group>[].obs;  // Cria uma lista observável de grupos, que é reativa e pode ser observada por widgets
  final box = GetStorage();  // Cria uma instância de GetStorage para ler e escrever dados no armazenamento local

  @override
  void onInit() {
    super.onInit();  // Chama o método onInit da classe base GetxController
    // Tenta ler os grupos armazenados localmente
    List<dynamic>? storedGroups = box.read<List<dynamic>>('grupos');
    if (storedGroups != null) {  // Se grupos armazenados foram encontrados
      // Converte os dados armazenados em objetos Group e Player
      groups.assignAll(storedGroups.map((group) => Group(
        name: group['name'],  // Define o nome do grupo
        players: List<Player>.from(group['players'].map((player) => Player(
          name: player['name'],  // Define o nome do jogador
          position: player['position'],  // Define a posição do jogador
          skillRating: player['skillRating'],  // Define a nota de habilidade do jogador
          speed: player['speed'],  // Define a velocidade do jogador
          phase: player['phase'],  // Define a fase do jogador
          movement: player['movement'],  // Define a movimentação do jogador
          photoUrl: player['photoUrl'],  // Define a URL da foto do jogador
          isChecked: player['isChecked'] ?? false,  // Define o estado da checkbox, padrão é falso se não definido
        ))),
      )));
    }
  }

  // Adiciona um novo grupo à lista de grupos e salva no armazenamento local
  void addGroup(Group group) {
    groups.add(group);  // Adiciona o grupo à lista de grupos
    _saveToStorage();  // Salva a lista atualizada de grupos no armazenamento local
  }

  // Remove um grupo da lista de grupos e salva a alteração no armazenamento local
  void removeGroup(Group group) {
    groups.remove(group);  // Remove o grupo da lista de grupos
    _saveToStorage();  // Salva a lista atualizada de grupos no armazenamento local
  }

  // Adiciona um jogador a um grupo específico e salva a alteração no armazenamento local
  void addPlayerToGroup(Group group, Player player) {
    final index = groups.indexWhere((g) => g.name == group.name);  // Encontra o índice do grupo na lista
    if (index != -1) {  // Verifica se o grupo foi encontrado
      groups[index].players.add(player);  // Adiciona o jogador à lista de jogadores do grupo
      _saveToStorage();  // Salva a lista atualizada de grupos no armazenamento local
    }
  }

  // Atualiza o estado da checkbox de um jogador em um grupo específico e salva a alteração
  void updatePlayerCheckedState(Group group, Player player) {
    final index = groups.indexWhere((g) => g.name == group.name);  // Encontra o índice do grupo na lista
    if (index != -1) {  // Verifica se o grupo foi encontrado
      final playerIndex = groups[index].players.indexWhere((p) => p.name == player.name);  // Encontra o índice do jogador na lista de jogadores
      if (playerIndex != -1) {  // Verifica se o jogador foi encontrado
        groups[index].players[playerIndex].isChecked = player.isChecked;  // Atualiza o estado da checkbox
        _saveToStorage();  // Salva a lista atualizada de grupos no armazenamento local
      }
    }
  }

  // Remove jogadores selecionados (com checkbox marcada) de um grupo específico e salva a alteração
  void removeCheckedPlayers(Group group) {
    final index = groups.indexWhere((g) => g.name == group.name);  // Encontra o índice do grupo na lista
    if (index != -1) {  // Verifica se o grupo foi encontrado
      groups[index].players.removeWhere((p) => p.isChecked);  // Remove jogadores com a checkbox marcada
      _saveToStorage();  // Salva a lista atualizada de grupos no armazenamento local
    }
  }

  // Atualiza as informações de um jogador específico em um grupo e salva a alteração
  void updatePlayer(Group group, Player updatedPlayer) {
    final index = groups.indexWhere((g) => g.name == group.name);  // Encontra o índice do grupo na lista
    if (index != -1) {  // Verifica se o grupo foi encontrado
      final playerIndex = groups[index].players.indexWhere((p) => p.name == updatedPlayer.name);  // Encontra o índice do jogador na lista de jogadores
      if (playerIndex != -1) {  // Verifica se o jogador foi encontrado
        groups[index].players[playerIndex] = updatedPlayer;  // Atualiza as informações do jogador
        _saveToStorage();  // Salva a lista atualizada de grupos no armazenamento local
      }
    }
  }

  // Salva a lista atualizada de grupos no armazenamento local
  void _saveToStorage() {
    box.write('grupos', groups.map((g) => {
      'name': g.name,  // Armazena o nome do grupo
      'players': g.players.map((p) => {
        'name': p.name,  // Armazena o nome do jogador
        'position': p.position,  // Armazena a posição do jogador
        'skillRating': p.skillRating,  // Armazena a nota de habilidade do jogador
        'speed': p.speed,  // Armazena a velocidade do jogador
        'phase': p.phase,  // Armazena a fase do jogador
        'movement': p.movement,  // Armazena a movimentação do jogador
        'photoUrl': p.photoUrl,  // Armazena a URL da foto do jogador
        'isChecked': p.isChecked,  // Armazena o estado da checkbox do jogador
      }).toList(),
    }).toList());
  }
}
