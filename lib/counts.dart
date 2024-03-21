//Provider 기능 사용하기 위한 애들 모아놓은 클래스

import 'package:flutter/material.dart';
import 'package:rli_discovery/variables/variable.dart';
import 'package:rli_discovery/variables/variable_erli.dart';
import 'package:rli_discovery/variables/variable_pit.dart';

//이건 아마 PIT 검사할때 썼었나 그럴거
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

  /// 1지원안함
  ///
  /// 2 RLI 2버전
  ///
  /// 3 ERLI 1버전
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
    } else if (i == 3) {
      const temp = ERLIType.values;
      _answer.clear();

      for (ERLIType ff in temp) {
        _answer.addAll({ff.code: []});
        for (int i = 0; i < ERLI.erli[ff]!.length; i++) {
          _answer[ff.code]!.add(false);
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

//이건 이제 검사 할때 유저 이름이랑 스토리지 정보를 수집해 저장하는 전역변수 역할 하는 클래스
class PreferencesRLITestApp with ChangeNotifier {
  bool _isDebugMode = false;
  String _userName = "";
  String _userId = "";
  String _storage = "";
  int instance = 16888214;

  void toggleDebugMode() {
    if (_isDebugMode) {
      _isDebugMode = false;
      notifyListeners();
    } else {
      notifyListeners();
      _isDebugMode = true;
    }
  }

  void setUserName(String name, String storage) {
    _userName = name;
    DateTime dt = DateTime.now();
    String path =
        "${dt.year}${dt.month}${dt.day}h${dt.hour}m${dt.minute}s${dt.second}";
    instance = dt.year + dt.month + dt.day + dt.hour + dt.minute + dt.second;
    _userId = "$name$path";
    _storage = storage;
    debugPrint(
        "Info: User Infomation Setting: -storage: $_storage -name $_userName -idCode $_userId -seed $instance");
    notifyListeners();
  }

  get userId => _userId;
  get userName => _userName;
  get isDebugging => _isDebugMode;
  get storage => _storage;
  get seed => instance;
}

class PITAnswers with ChangeNotifier {
  bool isInitialized = false;
  Map<PITType, List<bool>> answers = {};
  void init() {
    answers.clear();
    for (PITType factor in PIT.pit.keys) {
      answers.addAll({factor: []});
      while (answers[factor]!.length < PIT.pit[factor]!.length) {
        answers.update(
          factor,
          (value) {
            value.add(false);
            return value;
          },
          ifAbsent: () {
            return [false];
          },
        );
      }
    }
    isInitialized = true;
    notifyListeners();
  }

  void updateAnswer(
      {required PITType factor, required int number, bool? value}) {
    if (!isInitialized) {
      throw Exception(
          "thrown Exception at updating. The Line is not initalized!");
    }
    if (answers[factor] == null) {
      throw Exception(
          "thrown Exception at updating. $factor,$number. because ${answers.keys}");
    }
    if (answers[factor]!.length - 1 < number) {
      throw Exception(
          "thrown Exception at updating. $factor,$number. because ${answers[factor]!.length}");
    }
    List<bool> sets = answers[factor]!;
    if (value == null) {
      sets[number] = !sets[number];
    } else {
      sets[number] = value;
    }
    answers.update(factor, (value) {
      return sets;
    });
    notifyListeners();
  }

  bool getAnswer({required PITType factor, required int number}) {
    if (!isInitialized) {
      throw Exception(
          "thrown Exception at getting. The Line is not initalized!");
    }
    if (answers[factor] == null) {
      throw Exception(
          "thrown Exception at getting. $factor,$number. because ${answers.keys}");
    }
    if (answers[factor]!.length - 1 < number) {
      throw Exception(
          "thrown Exception at getting. $factor,$number. because ${answers[factor]!.length}");
    }
    return answers[factor]![number];
  }
}

//이건 타임스태프
class TimeStaff with ChangeNotifier {
  List<String> staff = [];
  int last = 0;

  void init() {
    staff = [];
    DateTime dt = DateTime.now();
    last = dt.millisecondsSinceEpoch;
    staff.add("Start|0");
    notifyListeners();
  }

  /// 타임스테프의 행적을 기록합니다
  void add(String factor, int number) {
    DateTime dt = DateTime.now();
    int i = dt.millisecondsSinceEpoch - last;
    staff.add(
        "$factor,$number|${(i / 60000).floor()}m ${((i % 60000) / 1000).floor()}s/${i % 1000}");
    last = dt.millisecondsSinceEpoch;
    notifyListeners();
  }

  ///타입스테프의 비정형 정보를 기록합니다.
  void addSelf(String self) {
    DateTime dt = DateTime.now();
    int i = dt.millisecondsSinceEpoch - last;
    staff.add(
        "$self|${(i / 60000).floor()}m ${((i % 60000) / 1000).floor()}s/${i % 1000}");
    last = dt.millisecondsSinceEpoch;
    notifyListeners();
  }
}
