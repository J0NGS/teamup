import 'package:flutter/material.dart';  // Importa o pacote Flutter Material para criar widgets e temas
import 'package:get/get.dart';  // Importa o pacote GetX para gerenciamento de estado e navegação
import 'package:teamup/controllers/group_controller.dart';  // Importa o controlador de grupos
import 'package:teamup/models/group.dart';  // Importa o modelo de grupo
import 'package:teamup/models/player.dart';  // Importa o modelo de jogador
import 'package:teamup/utils/colors.dart';  // Importa o arquivo de cores personalizado

class PlayerCreationScreen extends StatefulWidget {
  final Group group;  // Grupo ao qual o jogador será adicionado

  PlayerCreationScreen({required this.group});

  @override
  _PlayerCreationScreenState createState() => _PlayerCreationScreenState();
}

class _PlayerCreationScreenState extends State<PlayerCreationScreen> {
  final TextEditingController _nameController = TextEditingController();  // Controlador para o campo de nome
  String _selectedPosition = 'Atacante';  // Posição selecionada inicialmente
  int _skillRating = 0;  // Nota de habilidade inicial
  int _speed = 1;  // Velocidade inicial
  int _phase = 1;  // Fase inicial
  int _movement = 1;  // Movimentação inicial
  String _photoUrl = '';  // URL da foto inicial

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Jogador', style: TextStyle(color: Colors.white)),  // Título da AppBar
        backgroundColor: Black100,  // Cor de fundo da AppBar
        iconTheme: const IconThemeData(color: Colors.green),  // Cor dos ícones da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Padding ao redor do corpo da tela
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Implementar lógica para adicionar a foto
              },
              child: Container(
                color: Black100,  // Cor de fundo do container da foto
                width: double.infinity,  // Largura do container
                height: 150,  // Altura do container
                child: Center(
                  child: _photoUrl.isEmpty
                      ? Icon(Icons.person, color: Colors.green, size: 100)  // Ícone padrão se não houver foto
                      : Image.network(_photoUrl),  // Exibe a imagem se a URL estiver disponível
                ),
              ),
            ),
            const SizedBox(height: 20),  // Espaço entre o container da foto e o próximo widget
            TextField(
              controller: _nameController,  // Controlador para o campo de texto do nome
              decoration: const InputDecoration(
                labelText: 'Nome',  // Rótulo do campo de texto
                labelStyle: TextStyle(color: Colors.green),  // Cor do rótulo
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),  // Cor da borda do campo de texto quando habilitado
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),  // Cor da borda do campo de texto quando focado
                ),
              ),
              style: const TextStyle(color: Colors.white),  // Cor do texto
            ),
            const SizedBox(height: 20),  // Espaço entre o campo de texto do nome e o DropdownButton
            DropdownButton<String>(
              value: _selectedPosition,  // Valor selecionado no DropdownButton
              dropdownColor: Black100,  // Cor de fundo do DropdownButton
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPosition = newValue!;  // Atualiza a posição selecionada
                });
              },
              items: <String>['Atacante', 'Meia', 'Defensor', 'Goleiro']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.white)),  // Texto das opções do DropdownButton
                );
              }).toList(),
              hint: const Text('Selecione a Posição', style: TextStyle(color: Colors.white)),  // Texto do hint
              iconEnabledColor: Colors.green,  // Cor do ícone do DropdownButton
            ),
            const SizedBox(height: 20),  // Espaço entre o DropdownButton e o campo de texto da nota de habilidade
            TextField(
              keyboardType: TextInputType.number,  // Tipo de teclado para números
              decoration: const InputDecoration(
                labelText: 'Nota de Habilidade (0-100)',  // Rótulo do campo de texto
                labelStyle: TextStyle(color: Colors.green),  // Cor do rótulo
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),  // Cor da borda do campo de texto quando habilitado
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),  // Cor da borda do campo de texto quando focado
                ),
              ),
              style: const TextStyle(color: Colors.white),  // Cor do texto
              onChanged: (value) {
                setState(() {
                  _skillRating = int.tryParse(value) ?? 0;  // Atualiza a nota de habilidade
                });
              },
            ),
            const SizedBox(height: 10),  // Espaço entre o campo de texto da nota de habilidade e o Slider da velocidade
            Row(
              children: [
                const Text('Velocidade', style: TextStyle(color: Colors.white)),  // Rótulo do Slider
                Expanded(
                  child: Slider(
                    value: _speed.toDouble(),  // Valor atual do Slider
                    min: 1,  // Valor mínimo do Slider
                    max: 3,  // Valor máximo do Slider
                    divisions: 2,  // Número de divisões no Slider
                    onChanged: (value) {
                      setState(() {
                        _speed = value.toInt();  // Atualiza a velocidade
                      });
                    },
                    label: '$_speed',  // Rótulo do Slider
                    activeColor: Colors.green,  // Cor ativa do Slider
                    inactiveColor: Colors.white30,  // Cor inativa do Slider
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),  // Espaço entre o Slider da velocidade e o Slider da fase
            Row(
              children: [
                const Text('Fase', style: TextStyle(color: Colors.white)),  // Rótulo do Slider
                Expanded(
                  child: Slider(
                    value: _phase.toDouble(),  // Valor atual do Slider
                    min: 1,  // Valor mínimo do Slider
                    max: 3,  // Valor máximo do Slider
                    divisions: 2,  // Número de divisões no Slider
                    onChanged: (value) {
                      setState(() {
                        _phase = value.toInt();  // Atualiza a fase
                      });
                    },
                    label: '$_phase',  // Rótulo do Slider
                    activeColor: Colors.green,  // Cor ativa do Slider
                    inactiveColor: Colors.white30,  // Cor inativa do Slider
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),  // Espaço entre o Slider da fase e o Slider da movimentação
            Row(
              children: [
                const Text('Movimentação', style: TextStyle(color: Colors.white)),  // Rótulo do Slider
                Expanded(
                  child: Slider(
                    value: _movement.toDouble(),  // Valor atual do Slider
                    min: 1,  // Valor mínimo do Slider
                    max: 3,  // Valor máximo do Slider
                    divisions: 2,  // Número de divisões no Slider
                    onChanged: (value) {
                      setState(() {
                        _movement = value.toInt();  // Atualiza a movimentação
                      });
                    },
                    label: '$_movement',  // Rótulo do Slider
                    activeColor: Colors.green,  // Cor ativa do Slider
                    inactiveColor: Colors.white30,  // Cor inativa do Slider
                  ),
                ),
              ],
            ),
            const Spacer(),  // Espaço flexível para empurrar os botões para o fundo
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);  // Volta à tela anterior sem salvar alterações
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,  // Cor de fundo do botão
                  ),
                  child: const Text(
                    'Cancelar',  // Texto do botão
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),  // Estilo do texto
                  ),
                ),
                const Spacer(),  // Espaço flexível entre os botões
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      final newPlayer = Player(
                        name: _nameController.text,
                        position: _selectedPosition,
                        skillRating: _skillRating,
                        speed: _speed,
                        phase: _phase,
                        movement: _movement,
                        photoUrl: _photoUrl,
                      );

                      // Adiciona o jogador ao grupo e persiste as alterações
                      final GroupController groupController = Get.find<GroupController>();
                      groupController.addPlayerToGroup(widget.group, newPlayer);

                      // Volta à tela anterior e passa um resultado para indicar a mudança
                      Get.back(result: true);
                    }
                  },
                  child: const Text(
                    'Continuar',  // Texto do botão
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),  // Estilo do texto
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: BackgroundBlack,  // Cor de fundo da tela
    );
  }
}
