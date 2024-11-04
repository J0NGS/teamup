import 'package:intl/intl.dart';

class Event {
  String id;
  DateTime date;
  Duration matchTime;
  String place;
  String groupId;
  bool isFinished;

  Event({
    required this.id,
    required this.date,
    required this.matchTime,
    required this.place,
    required this.groupId,
    this.isFinished = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': DateFormat('dd/MM/yyyy HH:mm').format(date),
      'matchTime': matchTime.inSeconds,
      'place': place,
      'groupId': groupId,
      'isFinished': isFinished ? 1 : 0,
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      date: DateFormat('dd/MM/yyyy HH:mm').parse(map['date']),
      matchTime: Duration(seconds: int.parse(map['matchTime'].toString())),
      place: map['place'],
      groupId: map['groupId'],
      isFinished: map['isFinished'] == 1,
    );
  }

  String get formattedDate {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(date);
  }
}
