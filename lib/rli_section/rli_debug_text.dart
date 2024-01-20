import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';

class TextualVision extends StatefulWidget {
  const TextualVision({super.key});

  @override
  State<TextualVision> createState() => _TextualVisionState();
}

class _TextualVisionState extends State<TextualVision> {
  String data = "";

  @override
  Widget build(BuildContext context) {
    if (context.watch<Answers2>().init == true) {
      setState(() {
        data = "It is not Initialized";
      });
    } else {
      Map<String, List<bool>> answers = context.watch<Answers2>().getSet;
      Iterator iter = answers.keys.iterator;
      data = "";
      while (iter.moveNext()) {
        String factor = iter.current;
        final List<bool> temp = answers[factor]!;
        int v = 0;
        for (int i = 0; i < temp.length; i++) {
          if (temp[i]) {
            v++;
          }
        }
        data = "$data $factor: $v";
      }
      setState(() {});
    }
    return Text(data);
  }
}
