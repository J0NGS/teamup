import 'package:flutter/material.dart';
import 'package:teamup/utils/colors.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupName;

  GroupDetailScreen({required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName, style: TextStyle(color: Colors.white),),
        backgroundColor: Black100,
        iconTheme: IconThemeData(
          color: Colors.green
        ),
      ),
      body: Center(
        child: Text(
          'Detalhes do grupo: $groupName',
          style: TextStyle(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ) ,
    backgroundColor: BackgroundBlack,
    );
  }
}
