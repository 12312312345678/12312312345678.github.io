import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:religous_lifetype_inventory/resultpage.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_vars.dart';

class RLIListWidget extends StatefulWidget {
  final List<RLITile> inv;
  const RLIListWidget({super.key, required this.inv});

  @override
  State<RLIListWidget> createState() => _RLIListWidgetState();
}

class _RLIListWidgetState extends State<RLIListWidget> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("검사중"),
        ),
        body: const CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("검사중"),
        actions: [
          IconButton(
              onPressed: () {
                Map<int, List<bool>> map = context.read<Answers>().getSet;
                debugPrint("===============================================");
                debugPrint(map.toString());
                debugPrint("===============================================");
                debugPrint("General D척도 계산중");

                //점수 저장하는 배열
                List<int> anters = [0, 0, 0, 0, 0];
                //긍정 팩터 일괄 연산
                for (int i = 1; i < 5; i++) {
                  if (map[i] != null) {
                    for (int j = 0; j < map[i]!.length; j++) {
                      if (map[i]![j] == true) {
                        anters[i - 1]++;
                      }
                    }
                  }
                }

                //부정 팩터 연산
                //선 점수반영. Pair 문제에 체크될 때마다 진실성 지수 증가
                for (int i = -4; i < 0; i++) {
                  for (int j = 0; j < map[i]!.length; j++) {
                    if (map[i]![j] == true) {
                      anters[4]++;
                    }
                  }
                }

                //후 점수반영, nonPair 문제에서 진실성 척도 검사

                //답변지 상수화

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ResultPage(
                        input: Result(results: anters, background: map))));
              },
              icon: const Icon(Icons.account_balance_sharp))
        ],
      ),
      body: ListView.builder(
          itemCount: widget.inv.length,
          itemBuilder: ((context, index) {
            return widget.inv[index];
          })),
    );
  }
}

//G 2버전 타일
class RLIQuestionTile extends StatefulWidget {
  // ||문제 O X|| 합산 결과를 상위 위젯으로 보내주는 기능 추가

  //D=1, S=2, H=3, R=4, P=5
  //n이 붙은 문항은 -1처리
  //E=0

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
    if (b!) {
      context.read<Answers2>().setAnswer(widget.factor, widget.number, true);
    } else {
      context.read<Answers2>().setAnswer(widget.factor, widget.number, false);
    }
  }
}
