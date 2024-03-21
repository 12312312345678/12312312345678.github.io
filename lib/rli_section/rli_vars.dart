import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';

class RLITile extends StatefulWidget {
  // ||문제 O X|| 합산 결과를 상위 위젯으로 보내주는 기능 추가

  //D=1, S=2, H=3, R=4, P=5
  //n이 붙은 문항은 -1처리
  //E=0

  final int factor;
  final String label;
  final int number;

  const RLITile(
      {super.key,
      required this.factor,
      required this.label,
      required this.number});

  @override
  State<RLITile> createState() => _RLITileState();
}

class _RLITileState extends State<RLITile> {
  bool ready = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text(widget.label),
      trailing: Checkbox(
        value: ready
            ? context.watch<Answers>().getAnswer(widget.factor, widget.number)
            : false,
        onChanged: doYes,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ready = true;
  }

  void doYes(bool? b) {
    if (b!) {
      context.read<Answers>().setAnswer(widget.factor, widget.number, true);
    } else {
      context.read<Answers>().setAnswer(widget.factor, widget.number, false);
    }
  }
}

class Result {
  final List<int> results;
  final Map<int, List<bool>> background;

  Result({required this.results, required this.background});
}

///각종 이미지파일 경로 저장한 enum
enum LAIPath {
  ///로고 이미지
  logo("assets/lobby_logo.webp"),
  test1("assets/lobby_test1.png"),
  test2("assets/lobby_test2.png"),
  test3("assets/lobby_test3.png");

  const LAIPath(this.path);
  final String path;
}
