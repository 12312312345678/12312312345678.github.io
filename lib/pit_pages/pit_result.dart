import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:rli_discovery/variables/variable_pit.dart';

class PITResult extends StatefulWidget {
  const PITResult({super.key});

  @override
  State<PITResult> createState() => _PITResultState();
}

class _PITResultState extends State<PITResult> {
  late final PITSheet _sheet;
  @override
  void initState() {
    super.initState();
    Map<PITType, List<bool>> inv = context.read<PITAnswers>().answers;
    Map<String, List<bool>> inventory = {};
    inv.forEach((key, value) {
      inventory[key.code] = value;
    });
    _sheet = PITSheet(
        idCode: context.read<PreferencesRLITestApp>().userId,
        uidName: context.read<PreferencesRLITestApp>().userName,
        inventory: inventory);
    _sheet.enroll(context.read<PreferencesRLITestApp>().storage,
        additional: {"timeStaff": context.read<TimeStaff>().staff});
  }

  @override
  Widget build(BuildContext context) {
    var map = _sheet.generate()!;
    List<Widget> w = [];
    for (String factor in map.keys) {
      w.add(Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: Text(
            "${PITType.parsing(factor).display}: ${map[factor]}/${PIT.pit[PITType.parsing(factor)]!.length}"),
      ));
    }
    w.add(const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text("PIT Survey"),
    ));
    return Scaffold(
      appBar: AppBar(title: const Text("결과 페이지")),
      body: Center(
        child: Column(children: w),
      ),
    );
  }
}
