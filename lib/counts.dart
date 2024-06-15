import 'package:rli_discovery/material/result_inveltory.dart';
import 'package:rli_discovery/variables/variable_general.dart';

class StaffAsignedSheet extends Sheet {
  StaffAsignedSheet(this.chatacter,
      {this.seed,
      required this.idCode,
      required this.inventory,
      required this.uidName});

  final TimeStaffChatacter chatacter;

  final int? seed;

  @override
  String idCode;

  @override
  Map<String, List<bool>> inventory;

  @override
  String uidName;

  void enrollWithStaff(String path) {
    enroll(path, additional: {"timeStaff": chatacter.staff, "seed": seed});
  }
}
