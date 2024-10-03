class Match {
  String id;
  String teamAId;
  String teamBId;
  List<String> goalsAId;
  List<String> goalsBId;

  Match(
      {required this.id,
      required this.teamAId,
      required this.teamBId,
      required this.goalsAId,
      required this.goalsBId});
}
