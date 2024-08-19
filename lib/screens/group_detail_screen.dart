import 'package:flutter/material.dart';  // Importa o pacote Flutter Material para criar widgets e temas
import 'package:get/get.dart';  // Importa o pacote GetX para gerenciamento de estado e navegação
import 'package:teamup/controllers/group_controller.dart';  // Importa o controlador de grupos
import 'package:teamup/models/group.dart';  // Importa a classe Group
import 'package:teamup/models/player.dart';  // Importa a classe Player
import 'package:teamup/screens/playerCreationScreen.dart';  // Importa a tela de criação de jogador
import 'package:teamup/screens/player_edit_screen.dart';  // Importa a tela de edição de jogador
import 'package:teamup/utils/colors.dart';  // Importa o arquivo de cores personalizado
import 'package:teamup/widgets/team_selection_modal.dart';  // Importa o modal para seleção de times

// Define uma tela para exibir os detalhes de um grupo específico
class GroupDetailScreen extends StatelessWidget {
  final Group group;  // Recebe um objeto Group como argumento

  GroupDetailScreen({required this.group});  // Construtor que inicializa a variável group

  // Função para obter a cor do skill rating com base no valor
  Color _getSkillRatingColor(int skillRating) {
    double ratio = skillRating / 100.0;  // Calcula a proporção do skill rating
    int red = (255 * (1 - ratio)).toInt();  // Calcula a intensidade do vermelho
    int green = (255 * ratio).toInt();  // Calcula a intensidade do verde
    return Color.fromARGB(255, red, green, 0);  // Retorna a cor resultante
  }

  @override
  Widget build(BuildContext context) {
    // Obtém uma instância do GroupController usando GetX
    final GroupController groupController = Get.find<GroupController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name, style: TextStyle(color: Colors.white)),  // Define o título da AppBar com o nome do grupo
        backgroundColor: Black100,  // Define a cor de fundo da AppBar
        iconTheme: IconThemeData(color: Colors.green),  // Define a cor dos ícones na AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),  // Define um ícone de delete
            onPressed: () {
              groupController.removeCheckedPlayers(group);  // Remove jogadores selecionados
              groupController.groups.refresh();  // Atualiza a lista de grupos
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Define o espaçamento interno ao redor do conteúdo
        child: Obx(() {
          // Atualiza a UI quando a lista de grupos é modificada
          final updatedGroup = groupController.groups.firstWhere((g) => g.name == group.name);
          final selectedPlayersCount = updatedGroup.players.where((p) => p.isChecked).length;  // Conta jogadores selecionados

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Alinha os filhos ao início da coluna
            children: [
              Text(
                'Detalhes do grupo: ${updatedGroup.name}',  // Texto de detalhes do grupo
                style: TextStyle(fontSize: 24, color: Colors.white),  // Estilo do texto
              ),
              SizedBox(height: 20),  // Espaçamento vertical entre o título e a lista de jogadores
              Expanded(
                child: ListView.builder(
                  itemCount: updatedGroup.players.length,  // Número total de jogadores
                  itemBuilder: (context, index) {
                    Player player = updatedGroup.players[index];  // Obtém o jogador na posição do índice
                    return Card(
                      color: Black100,  // Define a cor de fundo do cartão
                      margin: EdgeInsets.symmetric(vertical: 8.0),  // Margem vertical ao redor do cartão
                      child: InkWell(
                        onTap: () {
                          Get.to(() => PlayerEditScreen(group: updatedGroup, player: player))!.then((result) {
                            if (result == true) {
                              groupController.groups.refresh();  // Atualiza a lista de grupos se houver alteração
                            }
                          });
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),  // Padding interno do ListTile
                          leading: player.photoUrl.isEmpty
                              ? Icon(Icons.person, color: Colors.green, size: 50)  // Ícone padrão se não houver URL da foto
                              : Image.network(
                            player.photoUrl,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.person, color: Colors.green, size: 50);  // Ícone padrão se houver erro ao carregar a imagem
                            },
                          ),
                          title: Row(
                            children: [
                              Text(
                                player.name,
                                style: TextStyle(color: Colors.white, fontSize: 18.0),  // Nome do jogador
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: _getSkillRatingColor(player.skillRating),  // Cor de fundo baseada no skill rating
                                  borderRadius: BorderRadius.circular(8.0),  // Raio de curvatura dos cantos
                                ),
                                constraints: BoxConstraints(
                                  maxWidth: 80,
                                  minWidth: 80,
                                ),
                                child: Center(
                                  child: Text(
                                    '${player.skillRating}',  // Skill rating do jogador
                                    style: TextStyle(color: Colors.white, fontSize: 16.0),  // Estilo do texto
                                  ),
                                ),
                              ),
                              Spacer(flex: 100,),  // Espaçador flexível
                              Checkbox(
                                value: player.isChecked,  // Valor do Checkbox baseado no estado do jogador
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    player.isChecked = value;  // Atualiza o estado do Checkbox
                                    groupController.updatePlayerCheckedState(group, player);  // Atualiza o estado do jogador no controlador
                                    groupController.groups.refresh();  // Atualiza a lista de grupos
                                  }
                                },
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),  // Espaçamento vertical entre a lista de jogadores e o botão
              ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    TeamSelectionModal(selectedPlayersCount: selectedPlayersCount, group: group,),  // Exibe o modal para seleção de times
                    backgroundColor: Black100,  // Define a cor de fundo do modal
                    isScrollControlled: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 70),  // Tamanho mínimo do botão
                  backgroundColor: Colors.green,  // Cor de fundo do botão
                  padding: EdgeInsets.symmetric(vertical: 16.0),  // Padding interno do botão
                  alignment: Alignment.center,  // Alinhamento do conteúdo do botão
                ),
                child: Column(
                  children: [
                    Text(
                      'Selecionar Times',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),  // Texto do botão
                    ),
                    SizedBox(height: 4.0),  // Espaçamento vertical entre o texto do botão e o subtítulo
                    Text(
                      '$selectedPlayersCount jogadores selecionados',  // Texto exibindo a quantidade de jogadores selecionados
                      style: TextStyle(color: Colors.white, fontSize: 14.0),  // Estilo do subtítulo
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      backgroundColor: BackgroundBlack,  // Define a cor de fundo da tela
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => PlayerCreationScreen(group: group))!.then((result) {
            if (result == true) {
              groupController.groups.refresh();  // Atualiza a lista de grupos se um novo jogador for criado
            }
          });
        },
        backgroundColor: Colors.green,  // Cor de fundo do botão flutuante
        child: const Icon(Icons.add),  // Ícone do botão flutuante
      ),
    );
  }
}
