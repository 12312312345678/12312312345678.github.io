import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:religous_lifetype_inventory/rli_pages/rli_page_survey.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("d"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("AppVersion 1.0.0"),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("신앙 특징 검사, RLI에 오신 것을 환영합니다."),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "이 검사는 개신교 신자들 또는 개신교에 경험이 있는 사람들에게 특화되어 있습니다. 이 검사는 개신교에 대한 설문자의 인식을 수치화해 나타냅니다."),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "문제를 너무 진지하게 고민하지 마시고, 생각나는대로, 자신이 옳다고 생각하는 문장의 체크박스를 눌러주세요. 그리고 우측 상단 두 번째 버튼을 클릭해 결과를 분석합니다."),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]'))
                ],
                controller: controller,
                decoration:
                    const InputDecoration(labelText: "Enter Nickname here"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    if ((controller.text == "")) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("닉네임에 아무것도 입력되지 않았습니다."),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("닫기"))
                              ],
                            );
                          });
                      return;
                    }
                    context
                        .read<PreferencesRLITestApp>()
                        .setUserName(controller.text);
                    context.read<Answers2>().initAnswer(2);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RLI2SurveyScreen()));
                  },
                  child: const Text("Start")),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "자료 수집, 분석 패턴 연구, 응답 성향 연구를 위해서 닉네임과 검사 결과가 전송될 수 있습니다. 그 외의 개인정보에는 접근하지 않으니 안심하셔도 됩니다"),
            ),
          ],
        ),
      ),
    );
  }
}
