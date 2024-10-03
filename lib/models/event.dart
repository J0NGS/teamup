class Event {
  String id;
  DateTime date;
  List<String> matchsId;
  String groupId;

  Event(
      {required this.id,
      required this.date,
      required this.matchsId,
      required this.groupId});
}
