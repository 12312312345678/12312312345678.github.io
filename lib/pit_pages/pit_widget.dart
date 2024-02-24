import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:rli_discovery/variables/variable_pit.dart';

class PITTile extends StatefulWidget {
  PITTile({super.key, required this.factor, required this.number}) {
    if (PIT.pit[factor] == null) {
      throw Exception(
          "thrown Exception at create tile: $factor,$number. $factor is null");
    }
    if (PIT.pit[factor]!.length < number - 1) {
      throw Exception(
          "thrown Exception at create tile: $factor,$number. $number is null");
    }
    label = PIT.pit[factor]![number];
  }
  late final String label;
  final PITType factor;
  final int number;

  @override
  State<PITTile> createState() => _PITTileState();
}

class _PITTileState extends State<PITTile> {
  bool ready = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.label),
        trailing: Checkbox(
          value: context
              .watch<PITAnswers>()
              .getAnswer(factor: widget.factor, number: widget.number),
          onChanged: toggle,
        ));
  }

  void toggle(bool? b) {
    context
        .read<PITAnswers>()
        .updateAnswer(factor: widget.factor, number: widget.number);
    context.read<TimeStaff>().add(widget.factor.code, widget.number);
  }
}
