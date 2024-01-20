import 'package:flutter/material.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_vars.dart';

class Answers with ChangeNotifier {
  final Map<int, List<bool>> _answer = {
    1: [],
    2: [],
    3: [],
    4: [],
    -1: [],
    -2: [],
    -3: [],
    -4: []
  };

  void addAnswer(int factor) {
    _answer[factor]!.add(false);
  }

  void setAnswer(int factor, int number, bool isAnswer) {
    _answer[factor]![number] = isAnswer;
    notifyListeners();
  }

  bool getAnswer(int factor, int number) {
    return _answer[factor]![number];
  }

  get getSet => _answer;
}

class Answers2 with ChangeNotifier {
  final Map<String, List<bool>> _answer = {};
  bool init = true;

  void initAnswer(int i) {
    if (i == 1) {
    } else if (i == 2) {
      const temp = RLI.rli2;
      _answer.clear();

      Iterator iter = temp.keys.iterator;
      while (iter.moveNext()) {
        String key = iter.current;
        _answer.addAll({key: []});
        while (_answer[key]!.length < temp[key]!.length) {
          _answer[key]!.add(false);
        }
      }
      init = false;
      notifyListeners();
    } else {
      throw Exception("올바르지 않은 초기화 수단입니다. 요청: $i ");
    }
  }

  void addAnswer(String factor) {
    if (_answer[factor] == null) {
      _answer.addAll({factor: []});
      while (_answer[factor]!.length < RLI.rli2[factor]!.length) {
        _answer[factor]!.add(false);
      }
      debugPrint("답안지가 손상되어 $factor를 다시 초기화합니다.");
    }
    notifyListeners();
  }

  void setAnswer(String factor, int number, bool isAnswer) {
    if (_answer[factor] == null) {
      throw Exception(
          "답안지에 답을 옮기는 중 오류가 발생했습니다. 팩터: $factor는 답안지에 기록되지않은 팩터입니다. 현제 답안지의 팩터는 ${_answer.keys.toList()}입니다.");
    }
    if (_answer[factor]!.length < number) {
      throw Exception(
          "답안지에 답을 옮기는 중 오류가 발생했습니다. 팩터 $factor의 길이가 $number보다 작은 ${_answer[factor]!.length}문항까지 초기화 되어 있으므로 답안을 작성할 수 없었습니다.");
    }
    _answer[factor]![number] = isAnswer;
    notifyListeners();
  }

  bool getAnswer(String factor, int number) {
    if (init) {
      throw Exception("답안지에서 답을 추출하다가 오류가 발생했습니다. 답안지가 초기화되지 않았습니다.");
    }
    if (_answer[factor] == null) {
      throw Exception("답안지에서 답을 추출하다 오류가 발생했습니다. 팩터 $factor가 올바르게 정의되지 않았습니다.");
    }
    if (_answer[factor]!.length < number) {
      throw Exception(
          "답안지에서 답을 추출하다 오류가 발생했습니다. 팩터 $factor의 길이가 $number보다 작은 ${_answer[factor]!.length}문항까지 초기화 되어 있으므로 답안을 추출할 수 없었습니다.");
    }
    return _answer[factor]![number];
  }

  get getSet => _answer;
}

class PreferencesRLITestApp with ChangeNotifier {
  bool _isDebugMode = false;
  String _userName = "defaultName";
  String _userId = "defaultId";

  void toggleDebugMode() {
    if (_isDebugMode) {
      _isDebugMode = false;
      notifyListeners();
    } else {
      notifyListeners();
      _isDebugMode = true;
    }
  }

  void setUserName(String name) {
    _userName = name;
    DateTime dt = DateTime.now();
    String path =
        "${dt.year}${dt.month}${dt.day}${dt.hour}${dt.minute}${dt.second}";
    _userId = "$name$path";
    debugPrint(_userId);
    notifyListeners();
  }

  get userId => _userId;
  get userName => _userName;
  get isDebugging => _isDebugMode;
}
