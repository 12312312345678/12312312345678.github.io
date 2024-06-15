import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rli_discovery/material/result_inveltory.dart';
import 'package:rli_discovery/variables/variable_general.dart';

//G 구현방법
///ERLI 검사의 특징
///
///이 검사는 RLI 검사에서 독특한 특징이 나타난 사람에 대해 추가적으로 시행하는 검사로 기본적으로 성인 신앙인을 기준으로 만들어졌습니다.
///
///이 검사의 진행방식은 다른 검사와는 다르게, 하나의 문항에 집중하고 다른 문항과 비교할 수 없도록 한번에 하나의 문항만 볼 수 있도록 합니다. 동시에 다른 문항은 볼 수 없으며 메뉴를 통해 나가서 다른 문항으로 이동할 수 있지만 그렇게 나가더라도 해당 문항이 어떤 내용인지 알 수 없습니다.
///
/// 일반타입 묶어서 섞고, 안티 문항 섞어서 놓고,  더블 문항들만 묶어서 섞은 다음에, 두 개의 뭉치들을 순차적으로 내놓습니다.
/// 각 문항들을 섞어서 규칙에 따라서 만든 다음에 배열로 저장합니다. 그 후 타일 목록을 만듭니다.
/// 타일 목록은 토글하면 데이터시트를 수정합니다. 그리고 타일 목록에서는 Yes응답이랑 No응답을 체크할 수 있는 버튼을 줍니다. 버튼을 누르면 다음 문항으로 넘어가게 합니다.
///
/// 즉 문항 답하기페이지, 메뉴보기 페이지를 만들어야 한다
///
/// 메뉴보기페이지는 문항 번호랑 해당 번호가 yes인지 no인지 알려주고, 전체 응답수 보여준다
///
/// 메뉴보기 누를 때, 메뉴보기에서 나올 때(원래문항으로 들어갈 때), yes버튼 누를 떄, no 버튼 누를 때마다 Timestaff에 기록합니다.
// Menu up
// Menu Down
// Go to Tile no. <타일넘버> (<factor>,<number>)
// Answer yes Tile no. <타일넘버> (<factor>,<number>)
// Answer no Tile no. <타일넘버> (<factor>,<number>)
class EdtSurvey extends StatefulWidget {
  const EdtSurvey({super.key, required this.questionSet, this.seed});

  final AsignedQuestion questionSet;
  final int? seed;

  @override
  State<EdtSurvey> createState() => _EdtSurveyState();
}

class _EdtSurveyState extends State<EdtSurvey> {
  int index = 0;
  bool menu = false;
  List<EdtSurveyPage> tiles = [];
  bool init = true;
  final Map<String, List<bool>> _answer = {};
  final TimeStaffChatacter _staff = TimeStaffChatacter();

  @override
  void initState() {
    super.initState();
    //tiles.addAll(maniGenerator());
    tiles.addAll(maniGenerater(widget.seed ?? 144000, widget.questionSet));
    setState(() {
      init = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      return const Scaffold(
        body: CircularProgressIndicator(),
      );
    }
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text("${index + 1}/${tiles.length}"),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      toggleMenu();
                    });
                  },
                  icon: const Icon(Icons.menu)),
            ],
          ),
          body: tiles[index],
        ));
  }

  /// index 수치를 1개 올리고 setState 합니다.
  void pageUp() {
    if (index + 1 == tiles.length) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Inform"),
              content: const Text("마지막 문항에 도달했습니다. 종료할까요?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("아니요")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop<Map>(
                          context, {"staff": _staff, "answer": _answer});
                    },
                    child: const Text("네"))
              ],
            );
          });
      return;
    }

    setState(() {
      index++;
    });
  }

  /// index 수치를 1개 내리고 setState 합니다.
  void pageDown() {
    if (index == 0) {
      return;
    }
    setState(() {
      index--;
    });
  }

  /// menu를 바꿉니다. true면 false로 false면 true로
  void toggleMenu() {
    _staff.staffWriteRaw("toggle menu $menu");
    setState(() {
      menu = !menu;
    });
  }

  List<EdtSurveyPage> partialGenerator(
      String type, AsignedQuestion questionSet) {
    List<EdtSurveyPage> output = [];
    if (questionSet.questions[type] == null) {
      throw Exception(
          "$type은 ${questionSet.name}에서 유효하지 않은 팩터입니다. (at edtSurvay.PartialGenerator)");
    }
    final List<String> qList = questionSet.questions[type]!;
    for (int i = 0; i < qList.length; i++) {
      final String label = qList[i];
      output.add(EdtSurveyPage(
        factor: type,
        number: i,
        onAnswer: (type, i) {
          _staff.staffWrite(type, i, true);
          setAnswer(type, i, true);
          pageUp();
        },
        onDecepting: (type, i) {
          _staff.staffWrite(type, i, false);
          setAnswer(type, i, false);
          pageUp();
        },
        backButton: () {
          pageDown();
        },
        label: label,
      ));
    }
    return output;
  }

  List<EdtSurveyPage> maniGenerater(int seed, AsignedQuestion qSet) {
    List<EdtSurveyPage> output = [];
    for (dynamic factor in qSet.questions.keys) {
      output.addAll(partialGenerator(factor, qSet));
    }
    output.shuffle(Random(seed));
    return output;
  }

  void setAnswer(String factor, int number, bool isAnswer) {
    _answer.update(
      factor,
      (existingList) {
        // Ensure the list is long enough by adding false values if necessary
        while (existingList.length <= number) {
          existingList.add(false);
        }
        // Set the specified index to isAnswer
        existingList[number] = isAnswer;
        return existingList;
      },
      ifAbsent: () {
        // Create a new list with false values up to the specified index
        List<bool> newList = List.generate(number + 1, (index) => false);
        newList[number] = isAnswer;
        return newList;
      },
    );
  }
}

///ERLI 검사에서 문항 하나에 대답하는 위젯입니다.
///이 위젯은 ERLI 문항 하나를 제시하고 yes 또는 no 대답을 하도록 선택지를 제시합니다.
///
/// * [factor], 문제의 요소를 지정합니다.
/// * [number], 문제의 문항 번호를 지정합니다.
/// * [onAnswer], yes 버튼을 눌렀을 때 기능을 입력합니다. 요소로 factor와 number를 반환받습니다.
/// * [onDecepting], no 버튼을 눌렀을 때 기능을 입력합니다.
class EdtSurveyPage extends StatelessWidget {
  /// 어느 요소에 포함된 문제인지 설명합니다
  final String factor;

  /// 문항의 번호를 입력합니다.
  final int number;

  /// 문항에서 yes를 눌렀을 때 동작
  final Answering onAnswer;

  /// 문항에서 no를 눌렀을 때 동작
  final Answering onDecepting;

  /// 뒤로 가기 버튼을 눌렀을 때 동작
  final Function backButton;

  /// 문제 라벨
  final String label;

  const EdtSurveyPage(
      {super.key,
      required this.factor,
      required this.number,
      required this.onAnswer,
      required this.onDecepting,
      required this.backButton,
      required this.label});

  @override
  Widget build(BuildContext context) {
    final paddingValue = MediaQuery.of(context).size.width * 0.05;
    return Center(
        child: Column(
      children: [
        // 라벨
        Padding(
          padding: EdgeInsets.fromLTRB(paddingValue, 10.0, paddingValue, 10.0),
          child: Text(label),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 긍정응답 버튼
            ElevatedButton(
              onPressed: () {
                onAnswer(factor, number);
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.redAccent;
                } else if (states.contains(WidgetState.hovered)) {
                  return Colors.redAccent;
                } else {
                  return Colors.red[200];
                }
              })),
              child: const Text("네"),
            ),
            const SizedBox(
              width: 10.0,
            ),
            // 부정응답 버튼
            ElevatedButton(
              onPressed: () {
                onDecepting(factor, number);
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.green[200];
                } else if (states.contains(WidgetState.hovered)) {
                  return Colors.greenAccent;
                } else {
                  return Colors.green[200];
                }
              })),
              child: const Text("아니요"),
            )
          ],
        ),
        const SizedBox(height: 10.0),
        // 뒤로가기 버튼
        ElevatedButton(
          onPressed: () {
            backButton();
          },
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => Colors.lime[300])),
          child: const Text("이전 문항으로"),
        )
      ],
    ));
  }
}

typedef Answering = Function(String, int);
typedef Warping = Function(int);
