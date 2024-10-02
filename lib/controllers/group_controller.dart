import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/group.dart';
import '../services/group_storage_service.dart';

class GroupController extends GetxController {
  var groups = <Group>[].obs;
  final GroupStorageService _storageService = GroupStorageService();

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  Future<void> loadGroups() async {
    groups.value = await _storageService.readGroups();
  }

  Future<void> addGroup(Group group) async {
    await _storageService.createGroup(group);
    loadGroups();
  }

  Future<void> updateGroup(Group group) async {
    await _storageService.updateGroup(group);
    loadGroups();
  }

  Future<void> removeGroup(Group group) async {
    await _storageService.deleteGroup(group.id);
    loadGroups();
  }
}
