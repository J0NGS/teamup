import 'package:get/get.dart';

class EventDataController extends GetxController {
  var place = ''.obs;
  var matchTime = Duration().obs;

  void setEventData(String newPlace, Duration newMatchTime) {
    place.value = newPlace;
    matchTime.value = newMatchTime;
  }
}
