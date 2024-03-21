import 'package:flutter/material.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_vars.dart';

class MainTestPage extends StatelessWidget {
  const MainTestPage({super.key});

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the button width, considering the padding between buttons.
    double padding = 8.0; // Padding on each side of a button
    double buttonWidth = (screenWidth - padding * 6) / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Religious LifeType Inventory'),
      ),
      body: Column(children: [
        SizedBox(height: padding * 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: buttonWidth,
                height: 235, // 세로 크기는 고정
                child: TestButton(
                  image: LAIPath.test1.path,
                  title: 'RLI 검사',
                  subtitle: '신앙의 어려움, 회의감, 스트레스, 극단주의화를 측정합니다.',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/rli");
                  },
                ),
              ),
              SizedBox(width: padding),
              SizedBox(
                width: buttonWidth,
                height: 235, // 세로 크기는 고정
                child: TestButton(
                  image: LAIPath.test2.path,
                  title: 'PIT 검사',
                  subtitle: '신앙의 특색을 측정합니다.',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/pit");
                  },
                ),
              ),
              SizedBox(width: padding),
              SizedBox(
                width: buttonWidth,
                height: 235, // 세로 크기는 고정
                child: TestButton(
                  image: LAIPath.test3.path,
                  title: 'Expanded-RLI 검사',
                  subtitle: '신앙의 어려움, 회의감 등을 심층적으로 측정합니다. 시간이 오래 걸릴 수 있습니다.',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/erli");
                  },
                ),
              ),
              SizedBox(width: padding),
            ],
          ),
        ),
        SizedBox(height: padding * 6),
        const Text("Designed by ChatGPT and DALL-E"),
        const Text("App Version v5.0"),
      ]),
    );
  }
}

class TestButton extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const TestButton({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Image.asset(image, width: 100, height: 100), // 이미지 버튼
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(subtitle, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
