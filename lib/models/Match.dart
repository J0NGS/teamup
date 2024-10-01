class Match {
  String id;
  String date; // Formato: dd/mm/aaaa - hh:mm
  List<String> goalIds;

  Match({
    required this.id,
    required this.date,
    List<String>? goalIds,
  }) : goalIds = goalIds ?? [];
}