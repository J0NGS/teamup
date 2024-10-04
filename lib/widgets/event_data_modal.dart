import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:teamup/utils/colors.dart';

class EventDataModal extends StatelessWidget {
  final Function(String, Duration) onStart;

  EventDataModal({required this.onStart});

  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _matchTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Black100,
      title: Text('Dados do Evento', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _placeController,
            decoration: InputDecoration(
              labelText: 'Local',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          TextField(
            controller: _matchTimeController,
            decoration: InputDecoration(
              labelText: 'Duração (mm:ss)',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            readOnly: true,
            onTap: () async {
              final duration = await showModalBottomSheet<Duration>(
                context: context,
                builder: (BuildContext context) {
                  int minutes = 0;
                  int seconds = 0;
                  return Container(
                    color: Black100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Minutos',
                                      style: TextStyle(color: Colors.white)),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return NumberPicker(
                                        value: minutes,
                                        minValue: 0,
                                        maxValue: 59,
                                        onChanged: (value) {
                                          setState(() => minutes = value);
                                        },
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        selectedTextStyle: TextStyle(
                                            color: Colors.green, fontSize: 24),
                                        itemHeight: 50,
                                        itemWidth: 60,
                                        step: 1,
                                        haptics: true,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Segundos',
                                      style: TextStyle(color: Colors.white)),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return NumberPicker(
                                        value: seconds,
                                        minValue: 0,
                                        maxValue: 59,
                                        onChanged: (value) {
                                          setState(() => seconds = value);
                                        },
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        selectedTextStyle: TextStyle(
                                            color: Colors.green, fontSize: 24),
                                        itemHeight: 50,
                                        itemWidth: 60,
                                        step: 1,
                                        haptics: true,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(
                                Duration(minutes: minutes, seconds: seconds));
                          },
                          child:
                              Text('OK', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                        ),
                      ],
                    ),
                  );
                },
              );
              if (duration != null) {
                _matchTimeController.text =
                    '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
              }
            },
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            final place = _placeController.text;
            final matchTimeParts = _matchTimeController.text.split(':');
            final matchTime = Duration(
              minutes: int.parse(matchTimeParts[0]),
              seconds: int.parse(matchTimeParts[1]),
            );
            onStart(place, matchTime);
            Get.back();
          },
          child: Text('Iniciar', style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
