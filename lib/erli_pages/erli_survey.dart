import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:religous_lifetype_inventory/erli_pages/erli_result.dart';
import 'package:rli_discovery/variables/variable_erli.dart';

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
class ERLISurvey extends StatefulWidget {
  const ERLISurvey({super.key});

  @override
  State<ERLISurvey> createState() => _ERLISurveyState();
}

class _ERLISurveyState extends State<ERLISurvey> {
  int index = 0;
  bool menu = false;
  List<ERLISurveyPage> tiles = [];
  bool init = true;

  @override
  void initState() {
    super.initState();
    tiles.addAll(maniGenerator());
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
    } else if (!menu) {
      return Scaffold(
        appBar: AppBar(
          title: Text("${index + 1}/${tiles.length}"),
          actions: [
            IconButton(
                onPressed: () {
                  debugPrint(context.read<TimeStaff>().staff.toString());
                },
                icon: const Icon(Icons.abc)),
            IconButton(
                onPressed: () {
                  setState(() {
                    toggleMenu();
                  });
                },
                icon: const Icon(Icons.abc)),
          ],
        ),
        body: tiles[index],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("dfs"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    toggleMenu();
                  });
                },
                icon: const Icon(Icons.abc))
          ],
        ),
        body: ERLIMenuWidget(
          tiles: tiles,
          warpTo: (target) {
            setState(() {
              index = target;
            });
            toggleMenu();
          },
        ),
      );
    }
  }

  /// index 수치를 1개 올리고 setState 합니다.
  void pageUp() {
    if (index + 1 == tiles.length) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("ERLI Inform"),
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
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ERLIResult()));
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
    context.read<TimeStaff>().addSelf("toggle menu $menu");
    setState(() {
      menu = !menu;
    });
  }

  /// 질문 페이지를 자동으로 만들어줍니다. ERLIType을 넣어주면 그 유형의 모든 질문으로 질문지를 만들어줍니다.
  List<ERLISurveyPage> autoGenerator(ERLIType type) {
    List<ERLISurveyPage> t = [];
    for (int i = 0; i < ERLI.erli[type]!.length; i++) {
      t.add(ERLISurveyPage(
        factor: type,
        number: i,
        onAnswer: (type, i) {
          context.read<TimeStaff>().add(type.code, i);
          context.read<Answers2>().setAnswer(type.code, i, true);
          pageUp();
        },
        onDecepting: (type, i) {
          context.read<TimeStaff>().addSelf("${type.code},$i deccept");
          context.read<Answers2>().setAnswer(type.code, i, false);
          pageUp();
        },
        backButton: () {
          pageDown();
        },
      ));
    }
    return t;
  }

  List<ERLISurveyPage> maniGenerator() {
    List<ERLISurveyPage> chapter1 = [];
    chapter1.addAll(autoGenerator(ERLIType.generalDogmatic));
    chapter1.addAll(autoGenerator(ERLIType.generalFunctional));
    chapter1.addAll(autoGenerator(ERLIType.generalPiety));
    chapter1.addAll(autoGenerator(ERLIType.generalIdeological));
    chapter1.addAll(autoGenerator(ERLIType.dogmaDispens));
    chapter1.addAll(autoGenerator(ERLIType.dogmaExclusive));
    chapter1.addAll(autoGenerator(ERLIType.dogmaHeresy));
    chapter1.addAll(autoGenerator(ERLIType.dogmaIdolize));
    chapter1.addAll(autoGenerator(ERLIType.life1));
    chapter1.addAll(autoGenerator(ERLIType.reactionaryAttactive));
    chapter1.addAll(autoGenerator(ERLIType.reactionaryFoundamental));
    chapter1.addAll(autoGenerator(ERLIType.reactionaryIrcohensive));
    chapter1.addAll(autoGenerator(ERLIType.atheismFunctional));
    chapter1.addAll(autoGenerator(ERLIType.atheismPlurism));
    chapter1.addAll(autoGenerator(ERLIType.atheismScientifical));
    chapter1.addAll(autoGenerator(ERLIType.generalDogmaticAnti));
    chapter1.addAll(autoGenerator(ERLIType.dogmaDispensAnti));
    chapter1.addAll(autoGenerator(ERLIType.reactionaryAttactiveAnti));
    chapter1.addAll(autoGenerator(ERLIType.generalFunctionalAnti));
    chapter1.addAll(autoGenerator(ERLIType.dogmaExclusiveAnti));
    chapter1.addAll(autoGenerator(ERLIType.reactionaryFoundamentalAnti));
    chapter1.shuffle();
    List<ERLISurveyPage> chapter2 = [];
    chapter2.addAll(autoGenerator(ERLIType.life2));
    chapter2.addAll(autoGenerator(ERLIType.lifeAnti));
    chapter2.addAll(autoGenerator(ERLIType.generalDogmaticSecound));
    chapter2.addAll(autoGenerator(ERLIType.generalFunctionalSecound));
    chapter2.addAll(autoGenerator(ERLIType.generalIdeologicalSecound));
    chapter2.addAll(autoGenerator(ERLIType.generalPietySecound));
    chapter2.addAll(autoGenerator(ERLIType.dogmaDispensSecound));
    chapter2.addAll(autoGenerator(ERLIType.dogmaExclusiveSecound));
    chapter2.addAll(autoGenerator(ERLIType.dogmaHeresySecound));
    chapter2.addAll(autoGenerator(ERLIType.dogmaIdolizeSecound));
    chapter2.addAll(autoGenerator(ERLIType.reactionaryAttactiveSecound));
    chapter2.addAll(autoGenerator(ERLIType.reactionaryFoundamentalSecound));
    chapter2.addAll(autoGenerator(ERLIType.reactionaryIrcohensiveSecound));
    chapter2.addAll(autoGenerator(ERLIType.atheismFunctionalSecound));
    chapter2.addAll(autoGenerator(ERLIType.atheismPlurismSecound));
    chapter2.addAll(autoGenerator(ERLIType.atheismScientificalSecound));
    chapter2.addAll(autoGenerator(ERLIType.generalIdeologicalAnti));
    chapter2.addAll(autoGenerator(ERLIType.generalPietyAnti));
    chapter2.addAll(autoGenerator(ERLIType.dogmaHeresyAnti));
    chapter2.addAll(autoGenerator(ERLIType.dogmaIdolizeAnti));
    chapter2.addAll(autoGenerator(ERLIType.reactionaryIrcohensiveAnti));
    chapter2.addAll(autoGenerator(ERLIType.atheismFunctionalAnti));
    chapter2.addAll(autoGenerator(ERLIType.atheismPlurismAnti));
    chapter2.addAll(autoGenerator(ERLIType.atheismScientificalAnti));
    chapter2.shuffle();
    chapter1.addAll(chapter2);
    return chapter1;
  }
}

///ERLI 검사에서 문항 하나에 대답하는 위젯입니다.
///이 위젯은 ERLI 문항 하나를 제시하고 yes 또는 no 대답을 하도록 선택지를 제시합니다.
///
/// * [factor], 문제의 요소를 지정합니다.
/// * [number], 문제의 문항 번호를 지정합니다.
/// * [onAnswer], yes 버튼을 눌렀을 때 기능을 입력합니다. 요소로 factor와 number를 반환받습니다.
/// * [onDecepting], no 버튼을 눌렀을 때 기능을 입력합니다.
class ERLISurveyPage extends StatelessWidget {
  /// 어느 요소에 포함된 문제인지 설명합니다
  final ERLIType factor;

  /// 문항의 번호를 입력합니다.
  final int number;

  /// 문항에서 yes를 눌렀을 때 동작
  final Answering onAnswer;

  /// 문항에서 no를 눌렀을 때 동작
  final Answering onDecepting;

  /// 뒤로 가기 버튼을 눌렀을 때 동작
  final Function backButton;

  const ERLISurveyPage(
      {super.key,
      required this.factor,
      required this.number,
      required this.onAnswer,
      required this.onDecepting,
      required this.backButton});

  @override
  Widget build(BuildContext context) {
    final paddingValue = MediaQuery.of(context).size.width * 0.05;
    return Center(
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(paddingValue, 10.0, paddingValue, 10.0),
          child: Text(ERLI.erli[factor]![number]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                onAnswer(factor, number);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.redAccent;
                } else if (states.contains(MaterialState.hovered)) {
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
            ElevatedButton(
              onPressed: () {
                onDecepting(factor, number);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.green[200];
                } else if (states.contains(MaterialState.hovered)) {
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
        ElevatedButton(
          onPressed: () {
            backButton();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.lime[300])),
          child: const Text("이전 문항으로"),
        )
      ],
    ));
  }
}

typedef Answering = Function(ERLIType, int);
typedef Warping = Function(int);

class ERLIMenuWidget extends StatelessWidget {
  const ERLIMenuWidget({super.key, required this.tiles, required this.warpTo});
  final List<ERLISurveyPage> tiles;
  final Warping warpTo;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        String label = ERLI.erli[tiles[index].factor]![tiles[index].number];
        Color c = Colors.red[200]!;
        if (context
                .read<Answers2>()
                .getAnswer(tiles[index].factor.code, tiles[index].number) ==
            true) {
          c = Colors.green[200]!;
        }
        return ListTile(
          title: Text("${index + 1}. $label"),
          onTap: () {
            warpTo(index);
          },
          tileColor: c,
        );
      },
    );
  }
}
