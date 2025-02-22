import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/screens/group_detail_screen.dart';

class GroupsContainer extends StatelessWidget {
  const GroupsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: BackgroundBlack,
      child: Obx(() {
        final groupController = Get.put(GroupController());
        return groupController.groups.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centraliza verticalmente quando vazio
                children: [
                  Text(
                    "Nenhum grupo adicionado",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Scrollbar(
                thumbVisibility: true,
                thickness: 6.0,
                radius: const Radius.circular(10),
                trackVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinha os itens ao topo
                    children: [
                      ListView.builder(
                        shrinkWrap:
                            true, // Adiciona esta propriedade para evitar problemas de layout
                        physics:
                            const NeverScrollableScrollPhysics(), // Desativa a rolagem interna do ListView
                        itemCount: groupController.groups.length,
                        itemBuilder: (context, index) {
                          final group = groupController.groups[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 7.0, horizontal: 16.0),
                            color: Black100,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(2.0),
                              title: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Text(
                                    group.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18.0),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Black100,
                                        titleTextStyle: const TextStyle(
                                            color: Colors.green),
                                        title: const Text('Confirmar Exclusão'),
                                        content: const Text(
                                            'Você tem certeza que deseja excluir este grupo?',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancelar',
                                                style: TextStyle(
                                                    color: Colors.green)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Excluir',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () {
                                              groupController
                                                  .removeGroup(group);
                                              Navigator.of(context).pop();
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              onTap: () {
                                // Navega para a tela de detalhes do grupo
                                Get.to(() => GroupDetailScreen(group: group));
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
