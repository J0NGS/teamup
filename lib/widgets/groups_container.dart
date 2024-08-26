import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/screens/group_detail_screen.dart';

import '../screens/group_creation_screen.dart';

class GroupsContainer extends StatelessWidget {
  const GroupsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: BackgroundBlack,
      child: Center(
        child: Obx(() {
          final groupController = Get.find<GroupController>();
          return groupController.groups.isEmpty
              ? Column(
                  children: [
                    const Spacer(),
                    const Row(
                      children: [
                        Spacer(),
                        Text(
                          "Nenhum grupo adicionado",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Spacer()
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              Get.to(() => GroupCreationScreen());
                            },
                            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green), iconColor: WidgetStatePropertyAll(Colors.black87)),
                            child: const Icon(Icons.add),),
                        const Spacer()
                      ],
                    ),
                    const Spacer()
                  ],
                )
              : ListView.builder(
                  itemCount: groupController.groups.length,
                  itemBuilder: (context, index) {
                    final group = groupController.groups[index];
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(vertical: 7.0, horizontal: 16.0),
                      color: Black100,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          group.name,
                          style: const TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Remove o grupo da lista
                            groupController.removeGroup(group);
                          },
                        ),
                        onTap: () {
                          // Navega para a tela de detalhes do grupo
                          Get.to(() => GroupDetailScreen(group: group));
                        },
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }
}
