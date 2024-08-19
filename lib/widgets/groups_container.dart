import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/screens/group_detail_screen.dart';

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
          return groupController.groups.isEmpty
              ? Text('Nenhum grupo criado', style: TextStyle(color: Colors.white))
              : ListView.builder(
            itemCount: groupController.groups.length,
            itemBuilder: (context, index) {
              final group = groupController.groups[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: Black100,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    group.name,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
