import 'package:flutter/material.dart';
import 'package:rli_discovery/material/result_inveltory.dart';

class EDTResult extends StatefulWidget {
  const EDTResult({super.key, required this.result});
  final Sheet result;

  @override
  State<EDTResult> createState() => _EDTResultState();
}

class _EDTResultState extends State<EDTResult> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> scoring =
        widget.result.generate()!; // 수정된 점: generate() 메소드의 반환 타입에 맞게 수정
    debugPrint(scoring.toString());
    List<Widget> texts = [];
    List<String> kdf = scoring.keys.toList();
    kdf.sort();

    for (String factor in scoring.keys) {
      texts.add(ListTile(
        title: Text("$factor: ${scoring[factor]!}"),
      ));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Result Report")),
      body: ListView.builder(
          itemCount: texts.length,
          itemBuilder: (context, index) {
            return texts[index];
          }),
    );
  }
}
