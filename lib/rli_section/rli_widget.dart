import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';

class RLIQuestionTile extends StatefulWidget {
  final String factor;
  final String label;
  final int number;

  const RLIQuestionTile(
      {super.key,
      required this.factor,
      required this.label,
      required this.number});

  @override
  State<RLIQuestionTile> createState() => _RLIQuestionTileState();
}

class _RLIQuestionTileState extends State<RLIQuestionTile> {
  bool ready = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: context.watch<PreferencesRLITestApp>().isDebugging
          ? Text("${widget.factor}: ${widget.label} ${widget.number}")
          : Text(widget.label),
      trailing: Checkbox(
        value: ready
            ? context.watch<Answers2>().getAnswer(widget.factor, widget.number)
            : false,
        onChanged: toggle,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ready = true;
  }

  void toggle(bool? b) {
    context.read<TimeStaff>().add(widget.factor, widget.number);
    if (b!) {
      context.read<Answers2>().setAnswer(widget.factor, widget.number, true);
    } else {
      context.read<Answers2>().setAnswer(widget.factor, widget.number, false);
    }
  }
}
