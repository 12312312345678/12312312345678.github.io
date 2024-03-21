import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:religous_lifetype_inventory/pit_pages/pit_widget.dart';
import 'package:rli_discovery/variables/variable_pit.dart';

import 'pit_result.dart';

class PITSurveyWidget extends StatefulWidget {
  const PITSurveyWidget({super.key});

  @override
  State<PITSurveyWidget> createState() => _PITSurveyWidgetState();
}

class _PITSurveyWidgetState extends State<PITSurveyWidget> {
  List<PITTile> tiles = [];
  bool init = true;
  @override
  Widget build(BuildContext context) {
    if (init) {
      return const Scaffold(
        body: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("전체 문항수: ${tiles.length}"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PITResult()));
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: ListView.separated(
          itemBuilder: ((context, index) {
            return tiles[index];
          }),
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(thickness: 1);
          },
          itemCount: tiles.length),
    );
  }

  @override
  void initState() {
    super.initState();

    for (PITType factor in PIT.pit.keys) {
      for (int i = 0; i < PIT.pit[factor]!.length; i++) {
        tiles.add(PITTile(factor: factor, number: i));
      }
    }
    tiles.shuffle(Random(context.read<PreferencesRLITestApp>().instance));
    setState(() {
      init = false;
    });
  }
}
