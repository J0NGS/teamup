import 'package:flutter/material.dart';
import 'package:teamup/utils/colors.dart';

class ComingSoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundBlack,
      appBar: AppBar(
        title: Text(
          'Em breve...',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Black100,
      ),
      body: Center(
        child: Text(
          'Em breve...',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
