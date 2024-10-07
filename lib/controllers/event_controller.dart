import 'package:get/get.dart';
import 'package:teamup/models/event.dart';
import 'package:teamup/services/event_storage_service.dart';

class EventController extends GetxController {
  var events = <Event>[].obs;
  final EventStorageService _storageService = EventStorageService();

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  Future<Event?> getById(String id) async {
    return events.firstWhereOrNull((event) => event.id == id);
  }

  Future<void> loadEvents() async {
    events.value = await _storageService.readEvents();
  }

  Future<void> addEvent(Event event) async {
    await _storageService.createEvent(event);
    loadEvents();
  }

  Future<void> updateEvent(Event event) async {
    await _storageService.updateEvent(event);
    loadEvents();
  }

  Future<void> removeEvent(String id) async {
    await _storageService.deleteEvent(id);
    loadEvents();
  }

  Future<void> searchEventByGroupId(String groupId) async {
    events.value = await _storageService.searchEventByGroupId(groupId);
  }
}
