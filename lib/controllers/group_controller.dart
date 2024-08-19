import 'package:get/get.dart';

class GroupController extends GetxController {
  var grupos = <String>[].obs;

  void addGroup(String groupName) {
    grupos.add(groupName);
  }

  void removeGroup(String groupName) {
    grupos.remove(groupName);
  }
}
