import 'package:flutter/material.dart';

class UrunBilgiAlani extends StatelessWidget {
  const UrunBilgiAlani({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Lorem Ipsum",style: TextStyle(fontSize: 20),),
        const SizedBox(height: 4,),
        const Text("lorem ipsum lorem ipsum"),
      ],
    );
  }
}
