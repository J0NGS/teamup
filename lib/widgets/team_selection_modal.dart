import 'package:flutter/material.dart';
import 'package:teamup/models/group.dart';
import 'team_selection_modal_state.dart';

class TeamSelectionModal extends StatefulWidget {
  final Group group;
  final int selectedPlayersCount;

  const TeamSelectionModal(
      {super.key, required this.group, required this.selectedPlayersCount});

  @override
  TeamSelectionModalState createState() => TeamSelectionModalState();
}
