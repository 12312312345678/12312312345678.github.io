//Result Sheet Collector
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_vars.dart';

class ResultAdd {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void addResult(
      {required String name,
      required Result results,
      required String comments}) {
    DateTime dt = DateTime.now();
    String path =
        "${dt.year}${dt.month}${dt.day}${dt.hour}${dt.minute}${dt.second}";
    final resultRefer = db.collection("results").doc(path);
    resultRefer.set({
      "uidName": path,
      "results": results.results,
      "comments": "General Testing",
    }).then((value) {
      const backgroundKeys = ["-1", "-2", "-3", "-4", "1", "2", "3", "4"];
      var backgroundValues =
          backgroundKeys.map((key) => results.background[int.parse(key)]);

      var backgroundObject =
          Map.fromIterables(backgroundKeys, backgroundValues);

      resultRefer.collection("inventory").doc("dFactor").set(backgroundObject);
    });
  }
}

class ResultAdd2 {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void addResult({required BuildContext context, required String results}) {
    String path = context.read<PreferencesRLITestApp>().userId;
    final resultRefer = db.collection("results2").doc(path);
    resultRefer.set({
      "uidName": context.read<PreferencesRLITestApp>().userName,
      "results": results,
      "comments": "Version 2.0",
    }).then((value) {
      resultRefer
          .collection("inventory")
          .doc("dFactor")
          .set(context.read<Answers2>().getSet);
    });
  }
}
