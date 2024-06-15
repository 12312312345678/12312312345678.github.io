import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:religous_lifetype_inventory/edt_pages/edt_result.dart';
import 'package:religous_lifetype_inventory/edt_pages/edt_survey.dart';
import 'package:rli_discovery/material/result_inveltory.dart';

class EDTHome extends StatefulWidget {
  const EDTHome({super.key, required this.storage, required this.questionSet});
  final String storage;
  final AsignedQuestion questionSet;

  @override
  State<EDTHome> createState() => EDTHomePage();
}

class EDTHomePage extends State<EDTHome> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("닉네임 작성"),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("검사를 시작하기 위해 가명으로 사용될 닉네임을 입력해주세요."),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                  onPressed: () async {
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
                    DateTime dt = DateTime.now();
                    String qweqwe =
                        "y${dt.year}m${dt.month}d${dt.day}h${dt.hour}m${dt.minute}s${dt.second}";
                    StaffAsignedSheet st = await launchQuestion(context,
                        qSet: widget.questionSet,
                        uidName: controller.text,
                        storage: widget.storage,
                        idCode: "${controller.text}$qweqwe");
                    st.enrollWithStaff(widget.storage);
                    if (!mounted) return;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EDTResult(
                                  result: st,
                                )));
                  },
                  child: const Text("Start")),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                  "이 페이지는 모바일 이용자를 기준으로 제작되었으므로 PC 이용자분들은 브라우저의 가로 길이를 적절하게 조절해 더욱 원활하게 검사에 참여하실 수 있습니다."),
            ),
          ],
        ),
      ),
    );
  }

  Future<StaffAsignedSheet> launchQuestion(BuildContext context,
      {required String storage,
      required String idCode,
      required String uidName,
      required AsignedQuestion qSet,
      int? seed}) async {
    Map result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EdtSurvey(
                  questionSet: qSet,
                  seed: seed,
                )));
    return StaffAsignedSheet(result["staff"],
        idCode: idCode,
        inventory: result["answer"],
        uidName: uidName,
        seed: seed ?? 144000);
  }
}
