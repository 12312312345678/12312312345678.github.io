///각종 이미지파일 경로 저장한 enum
enum LAIPath {
  ///로고 이미지
  logo("assets/lobby_logo.webp"),
  test1("assets/lobby_test1.png"),
  test2("assets/lobby_test2.png"),
  test3("assets/lobby_test3.png"),
  test4("assets/lobby_test4.png"),
  test5("assets/lobby_test5.png"),
  test6("assets/lobby_test6.png");

  const LAIPath(this.path);
  final String path;
}

enum Languages {
  koLogoRLITitle("RLI 종교 스트레스 검사", "한국어"),
  koLogoRLIDesc("종교 스트레스, 교리 스트레스와 반동주의, 무신론 경향 편향을 종합적으로 검사합니다.", "한국어"),
  koLogoPITTitle("PIT 종교 특성 검사", "한국어"),
  koLogoPITDesc("", ""),
  koLogoEGTTitle("EGT 종합 스트레스 심층검사", "한국어"),
  koLogoEGTDesc("", ""),
  koLogoEDTTitle("EDT 교리 스트레스 심층검사", "한국어"),
  koLogoEDTDesc("", ""),
  koLogoEGPTTitle("EDPT 교리 인격형성 연관 검사", "한국어"),
  koLogoEGPTDesc("", ""),
  koLogoEDPTTitle("EGPT 종교 인격형성 연관 검사", "한국어"),
  koLogoEDPTDesc("", "한국어");

  final String label;
  final String language;
  const Languages(this.label, this.language);
}
