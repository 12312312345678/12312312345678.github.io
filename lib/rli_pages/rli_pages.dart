import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:religous_lifetype_inventory/rli_pages/rli_page_survey.dart';

class RLIHomePageScreen extends StatefulWidget {
  const RLIHomePageScreen({super.key, required this.storage});
  final String storage;

  @override
  State<RLIHomePageScreen> createState() => _RLIHomePageScreenState();
}

class _RLIHomePageScreenState extends State<RLIHomePageScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("RLI, Religious Lifetype Inventory testing"),
          ),
          body: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("신앙 특징 검사, RLI에 오신 것을 환영합니다."),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "이 검사는 개신교인과 개신교에 관해 경험이 있는 사람들에게 유용하며, 개신교에 대한 인식을 수치화하고 분석합니다."),
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
                            .setUserName(controller.text, widget.storage);
                        context.read<Answers2>().initAnswer(2);
                        context.read<TimeStaff>().init();

                        //타임스테프 시드 답지 등등 초기화하는 부분
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RLI2SurveyScreen()));
                      },
                      child: const Text("Start")),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      "이 페이지는 모바일 이용자를 기준으로 제작되었으므로 PC 이용자분들은 브라우저의 가로 길이를 적절하게 조절해 더욱 원활하게 검사에 참여하실 수 있습니다. 이 검사의 결과는 검사 결과의 패턴 분석을 위해 전송될 수 있으며 수집되는 정보는 검사 결과의 원점수와 답변 패턴입니다."),
                ),
              ],
            ),
          ),
        ));
  }
}
