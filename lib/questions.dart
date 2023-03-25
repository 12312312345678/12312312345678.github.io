import 'package:flutter/material.dart';

class Bible {
  final String book; //성경 권
  final int chapter; // 성경 장
  final int verse; // 성경 절
  late final String label; // 성경 내용
  static final Map<String, List<List<String>>> bible = {
    "Psalms": [
      [
        "시0, Psalms 0",
        "여호와의 뜻을 따르는 이들은",
        "여호와께서 행하시는 것을 갈망하고",
        "여호와의 뜻을 하는 이들은",
        "여호와께서 이 땅의 왕이 되심을 알지어다",
        "태초에 만물의 시작을 놓으신 여호와께서",
        "인생의 창조주가 되셨으며 인생의 경영자를 경영하시도다",
        "여호와의 뜻을 행하는 이들은",
        "여호와의 날을 갈망하나니",
        "여호와의 날이 도래하고 인생의 악이 드러나며",
        "곤고한 자와 가난한 자에게 구원을 행하시리라",
        "그러나, 여호와께서 의로운자와 행악자를 구별하시고",
        "여호와의 공의롭고 정의로운 잣대로 세계 만물을 판단하시리니",
        "행악자는 여호와를 없다 말하고, 어리석은 자는 여호와께 헌신하지 아니하겠노라 할지라도",
        "여호와께서는 이미 그들을 알고 그들을 감독하시도다."
      ],
      [
        "시1, Psalms 1",
        "복 있는 사람은 악인들의 꾀를 따르지 아니하며 죄인들의 길에 서지 아니하녀 오만한 자들의 바리에 앉지 아니하고",
        "오직 여호와의 율법을 즐거워하여 그의 율법을 주야로 묵상하는도다",
        "그는 시냇가에 심은 나무가 철을 따라 열매를 맺으며 그 잎사귀가 마르지 아니함 같으니 그가 하는 모든 일이 다 형통하리로다",
        "악인들은 그렇지 아니함이여 오직 바람에 나는 겨와 같도다",
        "그러므로 악인들은 심판을 견디지 못하며 죄인들이 의인들의 모임에 들지 못하리로다",
        "무릇 의인들의 길은 여호와께서 인정하시나 악인들의 길은 망하리로다"
      ],
      [
        "시2, Psalms 2",
        "어찌하여 이방 나라들이 분노하며 민족들이 헛된 일을 꾸미는가",
        "세상의 군왕들이 나서며 관원들이 서로 꾀하여 여호와가 그의 기름 부음 받은 자를 대적하며",
        "우리가 그들의 맨 것을 끊고 그의 결박을 벗어 버리자 하는도다",
        "하늘에 계신 이가 웃으심이여 주께서 그들을 비웃으시리로다",
        "그 때에 분을 말하며 그들을 놀라게 하여 이르시기를",
        "내가 나의 왕을 내 거룩한 산 시온에 세웠다 하시리로다",
        "내가 여호와의 명령을 전하노라 여호와께서 내게 이르시되 너는 내 아들이라 오늘 내가 너를 낳았도다",
        "내게 구하라 내가 이방 나라를 네 유업으로 주리니 네 소유가 땅 끝까지 이르리로다",
        "네가 철장으로 그들을 깨뜨림이여 질그릇 같이 부수리라 하시도다",
        "그런즉 균왕들아 너희는 지혜를 얻으며 세상의 제판관들아 너희는 교훈을 받을지어다",
        "여호와를 경외함으로 섬기고 떨며 즐거워할지어다",
        "그의 아들에게 입맞추라 그렇지 아니하면 진노하심으로 너희가 길에서 망하리니 그의 진노가 급하심이라 여호와께 피하는 모든 사람은 복이 있도다",
      ],
      [
        "시3 Psalms 3",
        "여호와여 나의 대적이 어찌 그리 많은지요 일어나 나를 치는 자가 많으니이다",
        "많은 사람이 나를 대적하여 말하기를 그는 하나님께 구원을 받지 못한다 하나이다",
        "여홍하여 주는 나의 방패이시요 나의 영광이시요 나의 머리를 드는 자이시니이다",
        "내가 나의 목소리로 여호와께 부르짖으니 그의 성산에서 응답하시는도다(셀라)",
        "내가 누워 자고 깨었으니 여호와께서 나를 붙드심이로다",
        "천만인이 나를 에워싸 진 친다 하여도 나는 두려워하지 아니하리이자",
        "여호와여 일어나소서 나의 하나님이여 나를 구원하소서 주깨서 나의 모든 원수의 뺨을 차시며 악인의 이를 꺾으셨나이다",
        "구원은 여호와께 있사오니 주의 복을 백성에게 내리소서 (셀라)"
      ],
      [
        "시4, Psalms 4",
        "내 의의 하나님이여 내가 부를 때에 응답하소서 곤란 중에 나를 너그럽게 하셨사오니 내게 은혜를 베푸사 나의 기도를 들으소서",
        "인생들아 어느 때까지 나의 영광을 비꾸어 욕되게 하며 헛된 일을 좋아하고 거짓을 구하려는가 (셀라)",
        "여호와께서 자기를 위하여 경건한 자를 택하신 줄 너희가 날지어다 내가 그를 부를 때에 여호와께서 들으시리로다",
        "너희는 떨며 범죄하지 말지어다 자리에 누워 심중에 말하고 잠잠할지어다 (셀라)",
        "의의 제사를 드리고 여호와를 의지할지어다",
        "여러 사람의 말이 우리에게 선을 보일 자가 누구뇨 하오니 여호와여 주의 얼굴을 우리에게 비추소서",
        "주께서 내 마음에 두신 기쁨은 그들의 곡식과 새 포도주가 풍성할 때보다 더하니이다",
        "내가 평안히 눕고 자기도 하리니 나를 안전히 살게 하시는 이는 오직 여호와시니이다"
      ],
      [
        "시5, Psalms 5",
        "여호와여 나의 말에 귀를 기울이사 나의 심정을 헤아려 주소서 ",
        "나의 왕, 니의 하나님이여 내가 부르짖는 소리를 들으시리니 아침에 내가 주께 기도하고 바라리이다",
        "주는 죄악을 기뻐하는 신이 아니시니 악이 주와 함께 머물지 못하며",
        "오만한 자들이 주의 목전에 서지 못하리이다 주는 모든 행악자를 미워하시며",
        "거짓말 하는 자들을 멸망시키시리이다 여호와께서는 피 흘리기를 즐기는 자와 속이는 자를 싫어하시나이다",
        "오직 나는 주의 풍성한 사랑을 힘입어 주의 집에 들어가 주를 경외한으로 성전을 향하여 예배하리이다",
        "여호와여 나의 원수들로 말미암아 주의 의로 나를 인도하시고 주의 길을 내 목전애 곧게 하소소",
        "그들의 입에 신실함이 없고 그들의 심중이 심히 악하며 그들의 목구멍은 열린 무덤 같고 그들의 혀로는 아첨하나이다",
        "하나님이여 그들을 정죄하사 자기 꾀에 빠지게 하시고 그 많은 허물로 말미암아 그들을 쫓아내소서 그들이 주를 배역함이니이다",
        "그러나 주깨 피하는 모든 사람은 다 기뻐하며 주의 보호로 말미암아 영원히 기뻐 외치고 주의 니름을 사랑하는 자들은 주를 즐거워하리이다",
        "여호와여 주는 의인에게 복을 주시고 방패와 같은 은혜로 그를 호위하시리이다"
      ],
      [
        "시6, Psalms 6",
        "여호와여 주의 분노로 나를 책망하지 마시오며 주의 진노로 나를 징계하지 마옵소서",
        "어호와여 내가 수척하였사오니 내게 은혜를 베푸소서 여호와여 나의 뼈가 떨리오니 나를 고치소서",
        "나의 영혼도 매우 떨리나이다 여호와여 어느 때까지니이까",
        "여호와여 돌아와 나의 영혼을 건지시며 주의 사랑으로 나를 구원하소서",
        "사망 중애는 주를 기억하는 일이 없사오니 스올에서 주께 감사할 자 누구리이까",
        "내가 탄식함으로 피곤하여 밤마다 눈물로 내 침상을 띄우며 내 요를 적시나이다",
        "내 눈이 근심으로 말미암아 쇠하녀 내 모든 대적으로 말미암아 어두워졌나이다",
        "악을 행하는 너희는 다 나를 떠나라 여호와께서 내 울음 소리를 들으셨도다",
        "여호와깨서 내 간구흘 들으셨음이여 여호와께서 내 기도를 받으시리로다",
        "내 모든 원수들이 부끄러움을 당하고 심히 떪이여 갑자기 부끄러워 물러가리로다"
      ],
      [
        "시7, Psalms 7",
        "여호와 내 하나님이여 내가 주께 피하오니 나를 쫓아오는 모든 자들에게서 나를 구원하여 내소서",
        "건져낼 자가 없으면 그들이 사다 같이 나를 찢고 뜯을까 하나이다",
        "여호와 내 하나님이여 내가 이런 일을 행하였거나 내 손에 죄악이 있더나",
        "화친한 자를 악으로 갚았거나 내 대적에게서 까닭 없이 빼앗았거든",
        "원수가 나의 영혼을 쫓아 잡아 내 생명을 땅에 짓밟개 하고 내 영광을 먼지 속에 살게 하소서 (셀라)",
        "여호와여 진노로 일어나사 내 대적들의 노를 막으시며 나를 위하여 깨소서 주께서 심판을 명령하셨나이다",
        "민족들의 모임이 주를 두르게 하시고 그 위 높은 자리에 돌아오소서",
        "여호와깨서 만민에게 심한을 행하시오니 여호와여 나의 의와 나의 성실함을 따라 나를 심판하소서",
        "악인의 악을 끊고 의인을 세우소서 의로우신 하나님이 사람과 마음과 양심을 감찰하시나이다",
        "나의 방패는 마음이 정직한 자를 구원하시는 하나님께 있도다",
        "하나님은 의로우신 제판장이심이여 매일 분노하시는 하나님이시로다",
        "사람이 회개하지 아니하면 그가 그의 칼을 가심이여 그의 활을 당기어 예비하셨도다",
        "죽일 도구를 또한 예비하심이여 그가 만든 화살은 불화살들이로다",
        "악인이 죄악을 낳음이여 재앙을 재어 거짓을 낳았도다",
        "그가 웅덩이를 파 만듦이여 제가 만든 함정에 빠졌도다",
        "그의 재앙은 자기 머리로 돌아가고 그의 포악은 자기 정슈리에 내리리로다",
        "내가 여호와께 그의 의를 따라 감사함이여 지존하신 여호와의 이름을 찬양하리로다."
      ],
    ]
  };

  Bible(this.book, this.chapter, this.verse) {
    if (bible[book] == null) {
      label = "ERROR";
      return;
    }
    label = bible[book]![chapter][verse];
  }
}

class BibleTile extends StatelessWidget {
  final Bible bib;

  const BibleTile(this.bib, {super.key});

  @override
  Widget build(BuildContext context) {
    final a = bib.chapter;
    final b = bib.verse;
    return ListTile(leading: const Icon(Icons.receipt), title: Text("$a/$b"), subtitle: Text(bib.label));
  }
}
