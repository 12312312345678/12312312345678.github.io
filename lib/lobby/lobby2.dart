import 'package:flutter/material.dart';

import '../rli_section/rli_vars.dart';

class Lobbie extends StatelessWidget {
  const Lobbie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기독교 심리 검사'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCard(LAIPath.test1.path, 'RLI 종교 스트레스 검사',
                '125문항으로 구성되어 있으며 무신론 지향성, 근본주의 지향성, 종합 스트레스, 교리 스트레스, 신앙 불안정성을 간편하게 측정할 수 있습니다.',
                () {
              Navigator.pushReplacementNamed(context, "/rli");
            }),
            buildCard(LAIPath.test2.path, 'PIT 종교 특성 검사',
                '신앙이 가지고 있는 네가지 성향을 측정합니다. 48문항으로 구성되어 있으며 경건주의, 포괄주의, 자유주의, 전통주의 등 4가지 영역에서 측정합니다.',
                () {
              Navigator.pushReplacementNamed(context, "/pit");
            }),
            buildCard(LAIPath.test4.path, 'EGT 종합 스트레스 심층검사',
                '기독교, 교회생활, 신앙생활에 대한 피로도와 회의감을 종합적으로 측정합니다. 총 83문항으로 구성되어 있습니다.',
                () {
              Navigator.pushReplacementNamed(context, "/egt1");
            }),
            buildCard(LAIPath.test5.path, 'EDT 교리 스트레스 심층검사',
                '교리적으로 가지고 있는 피로도를 종합적으로 측정합니다.', () {
              Navigator.pushReplacementNamed(context, "/edt1");
            }),
            buildCard(LAIPath.test6.path, 'EDPT 교리 인격형성 연관 검사',
                '교리 스트레스와 성격검사를 병행합니다.', () {
              Navigator.pushReplacementNamed(context, "/edpt1");
            }),
            buildCard(LAIPath.test6.path, 'EGPT 종교 인격형성 연관 검사',
                '종합 스트레스와 성격검사를 병행합니다.', () {
              Navigator.pushReplacementNamed(context, "/egpt1");
            }),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String imageUrl, String title, String description,
      VoidCallback onPressed) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
