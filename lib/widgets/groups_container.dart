import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/screens/group_detail_screen.dart'; // Importa a tela de detalhes

class GroupsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: BackgroundBlack,
      child: Center(
        child: Obx(() {
          final groupController = Get.find<GroupController>();
          return groupController.grupos.isEmpty
              ? Text('Nenhum grupo criado', style: TextStyle(color: Colors.white))
              : ListView.builder(
            itemCount: groupController.grupos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(groupController.grupos[index], style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navega para a tela de detalhes do grupo
                  Get.to(() => GroupDetailScreen(groupName: groupController.grupos[index]));
                },
              );
            },
          );
        }),
      ),
    );
  }
}
