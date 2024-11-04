import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:teamup/utils/colors.dart';

class EventDataModal extends StatelessWidget {
  final Function(String, Duration) onStart;

  EventDataModal({super.key, required this.onStart});

  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _matchTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Black100,
      title:
          const Text('Dados do Evento', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _placeController,
            decoration: const InputDecoration(
              labelText: 'Local',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          TextField(
            controller: _matchTimeController,
            decoration: const InputDecoration(
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
                                  const Text('Minutos',
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
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        selectedTextStyle: const TextStyle(
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
                                  const Text('Segundos',
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
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        selectedTextStyle: const TextStyle(
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
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text('OK',
                              style: TextStyle(color: Black100)),
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
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
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
          child: const Text('Iniciar', style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
