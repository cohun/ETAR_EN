import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/services/api_path.dart';
import 'package:flutter/material.dart';

abstract class Database {
  Future<void> createOperand(Operand operand);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createOperand(Operand operand) =>
      _setData(path: APIPath.operand(uid), data: operand.toMap());

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }
}
