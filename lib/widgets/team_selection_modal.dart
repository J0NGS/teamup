import 'package:flutter/material.dart';  // Importa o pacote Flutter Material para criar widgets e temas
import 'package:get/get.dart';  // Importa o pacote GetX para gerenciamento de estado e navegação
import 'package:teamup/controllers/group_controller.dart';  // Importa o controlador de grupo
import 'package:teamup/models/group.dart';  // Importa o modelo de grupo
import 'package:teamup/models/player.dart';  // Importa o modelo de jogador
import 'package:teamup/screens/team_result_screen.dart';  // Importa a tela de resultados dos times
import 'package:teamup/utils/colors.dart';  // Importa o arquivo de cores personalizado

class TeamSelectionModal extends StatefulWidget {
  final Group group;  // Objeto grupo que contém a lista de jogadores
  final int selectedPlayersCount;  // Quantidade de jogadores selecionados

  TeamSelectionModal({required this.group, required this.selectedPlayersCount});  // Construtor para receber o grupo e a quantidade de jogadores selecionados

  @override
  _TeamSelectionModalState createState() => _TeamSelectionModalState();  // Cria o estado para este widget
}

class _TeamSelectionModalState extends State<TeamSelectionModal> {
  final TextEditingController _teamCountController = TextEditingController();  // Controlador para o campo de quantidade de times
  bool _considerSpeed = true;  // Flag para considerar a velocidade na lógica de sorteio
  bool _considerMovement = true;  // Flag para considerar a movimentação na lógica de sorteio
  bool _considerPhase = true;  // Flag para considerar a fase na lógica de sorteio
  bool _considerPosition = true;  // Flag para considerar a posição na lógica de sorteio

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),  // Padding ao redor do modal
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,  // Alinha o conteúdo à esquerda
        mainAxisSize: MainAxisSize.min,  // Ajusta o tamanho do modal para o conteúdo
        children: [
          Text(
            'Configurações do Sorteio',  // Título do modal
            style: TextStyle(fontSize: 24, color: Colors.white),  // Estilo do texto
          ),
          SizedBox(height: 20),  // Espaço abaixo do título
          TextField(
            controller: _teamCountController,  // Controlador para o campo de texto
            keyboardType: TextInputType.number,  // Tipo de teclado numérico
            decoration: InputDecoration(
              labelText: 'Quantidade de times',  // Texto do rótulo
              labelStyle: TextStyle(color: Colors.green),  // Estilo do rótulo
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),  // Cor da borda quando habilitado
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),  // Cor da borda quando focado
              ),
            ),
            style: TextStyle(color: Colors.white),  // Estilo do texto
          ),
          SizedBox(height: 20),  // Espaço abaixo do campo de texto
          Text(
            'Considerar:',  // Texto para as opções de configuração
            style: TextStyle(fontSize: 18, color: Colors.white),  // Estilo do texto
          ),
          CheckboxListTile(
            title: Text('Velocidade', style: TextStyle(color: Colors.white)),  // Texto da opção
            value: _considerSpeed,  // Valor atual do checkbox
            onChanged: (bool? value) {
              setState(() {
                _considerSpeed = value ?? false;  // Atualiza o estado quando o checkbox é alterado
              });
            },
            activeColor: Colors.green,  // Cor quando o checkbox está selecionado
            checkColor: Colors.white,  // Cor do ícone do checkbox
          ),
          CheckboxListTile(
            title: Text('Movimentação', style: TextStyle(color: Colors.white)),  // Texto da opção
            value: _considerMovement,  // Valor atual do checkbox
            onChanged: (bool? value) {
              setState(() {
                _considerMovement = value ?? false;  // Atualiza o estado quando o checkbox é alterado
              });
            },
            activeColor: Colors.green,  // Cor quando o checkbox está selecionado
            checkColor: Colors.white,  // Cor do ícone do checkbox
          ),
          CheckboxListTile(
            title: Text('Fase', style: TextStyle(color: Colors.white)),  // Texto da opção
            value: _considerPhase,  // Valor atual do checkbox
            onChanged: (bool? value) {
              setState(() {
                _considerPhase = value ?? false;  // Atualiza o estado quando o checkbox é alterado
              });
            },
            activeColor: Colors.green,  // Cor quando o checkbox está selecionado
            checkColor: Colors.white,  // Cor do ícone do checkbox
          ),
          CheckboxListTile(
            title: Text('Posição', style: TextStyle(color: Colors.white)),  // Texto da opção
            value: _considerPosition,  // Valor atual do checkbox
            onChanged: (bool? value) {
              setState(() {
                _considerPosition = value ?? false;  // Atualiza o estado quando o checkbox é alterado
              });
            },
            activeColor: Colors.green,  // Cor quando o checkbox está selecionado
            checkColor: Colors.white,  // Cor do ícone do checkbox
          ),
          SizedBox(height: 20),  // Espaço abaixo das opções de configuração
          ElevatedButton(
            onPressed: () {
              _sortTeams();  // Chama a função para sortear os times ao pressionar o botão
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,  // Cor de fundo do botão
            ),
            child: Center(
              child: Text('Sortear'),  // Texto do botão
            ),
          ),
        ],
      ),
    );
  }

  void _sortTeams() {
    final int teamCount = int.tryParse(_teamCountController.text) ?? 0;  // Obtém a quantidade de times do campo de texto
    if (teamCount <= 0) {
      Get.snackbar('Erro', 'Quantidade de times inválida', backgroundColor: Colors.red, colorText: Colors.white);  // Exibe uma mensagem de erro se a quantidade for inválida
      return;
    }

    // Filtra jogadores selecionados que têm o atributo isChecked como verdadeiro
    final selectedPlayers = widget.group.players.where((player) => player.isChecked).toList();

    // Gera os times usando a lógica definida
    final sortedTeams = _generateTeams(selectedPlayers, teamCount);

    Get.to(() => TeamResultScreen(teams: sortedTeams));  // Navega para a tela de resultados dos times com os times gerados
  }

  List<List<Player>> _generateTeams(List<Player> players, int teamCount) {
    // Implementa a lógica de sorteio considerando os pesos
    // Exemplo básico de divisão igualitária sem considerar pesos específicos
    List<List<Player>> teams = List.generate(teamCount, (_) => []);  // Cria uma lista de listas para os times

    for (int i = 0; i < players.length; i++) {
      teams[i % teamCount].add(players[i]);  // Adiciona jogadores aos times de forma cíclica
    }

    return teams;  // Retorna a lista de times
  }
}
