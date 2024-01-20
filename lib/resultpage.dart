import 'package:flutter/material.dart';
import 'package:religous_lifetype_inventory/database_controller/firecontrol.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_vars.dart';

class ResultPage extends StatelessWidget {
  final Result input;

  const ResultPage({super.key, required this.input});
  @override
  Widget build(BuildContext context) {
    ResultAdd().addResult(name: 'dfsd', results: input, comments: 'sdfsd');
    return Scaffold(
      appBar: AppBar(title: const Text("결과창")),
      body: Center(
        child: Column(children: [
          Text("1: ${input.results[0]})"),
          Text("2: ${input.results[1]})"),
          Text("3: ${input.results[2]})"),
          Text("4: ${input.results[3]})"),
          Text("5: ${input.results[4]})"),
        ]),
      ),
    );
  }
}
