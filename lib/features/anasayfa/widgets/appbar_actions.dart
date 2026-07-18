import 'package:flutter/material.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: (){},icon: Icon(Icons.notifications),),
        Padding(
          padding: EdgeInsets.all(8),
          child: CircleAvatar(
            radius: 20,
            child: Text("İ"),
          ),
        ),
      ],
    );
  }
}