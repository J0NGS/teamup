import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/event_controller.dart';
import 'package:teamup/controllers/team_controller.dart';
import 'package:teamup/models/event.dart';
import 'package:teamup/models/team.dart';
import 'package:teamup/utils/colors.dart';
import 'event_screen.dart';

class GroupEventsScreen extends StatelessWidget {
  final String groupId;
  final EventController eventController = Get.put(EventController());
  final TeamController teamController = Get.put(TeamController());
  final RxBool isAscending = true.obs;

  GroupEventsScreen({super.key, required this.groupId});

  void _sortEvents(List<Event> events) {
    if (isAscending.value) {
      events.sort((a, b) => a.date.compareTo(b.date));
    } else {
      events.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  @override
  Widget build(BuildContext context) {
    eventController.searchEventByGroupId(groupId);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eventos do Grupo',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.green),
        backgroundColor: Black100,
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                isAscending.value ? Icons.arrow_downward : Icons.arrow_upward,
                color: Colors.green,
              ),
              onPressed: () {
                isAscending.value = !isAscending.value;
                eventController.events.refresh();
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        List<Event> events = eventController.events
            .where((event) => event.groupId == groupId)
            .toList();

        _sortEvents(events);

        if (events.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum evento encontrado',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        List<Event> numberedEvents = List.from(events);
        numberedEvents.sort((a, b) => a.date.compareTo(b.date));

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final eventNumber = numberedEvents.indexOf(event) + 1;
            return GestureDetector(
              onTap: () async {
                List<Team>? teams =
                    await teamController.getTeamsByEventId(event.id);
                Get.to(() => EventScreen(event: event, teams: teams));
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Black100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evento $eventNumber',
                      style: const TextStyle(color: Colors.green, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Local: ${event.place}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      'Data: ${event.formattedDate}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      backgroundColor: BackgroundBlack,
    );
  }
}
