import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/services/api_path.dart';
import 'package:flutter/material.dart';

abstract class Database {
  Future<void> createOperand(Operand operand);

  Future<void> getOperand(String uid);
  Future<void> getUser(String uid);

  Stream<List<Operand>> operandsStream();

  Future<void> updateOperand(Map<String, dynamic> operand);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createOperand(Operand operand) =>
      _setData(path: APIPath.operand(uid), data: operand.toMap());

  Future<void> getOperand(String uid) =>
      FirebaseFirestore.instance.collection('operands').doc(uid).get();
  Future<void> getUser(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid).get();

  Stream<List<Operand>> operandsStream() {
    final path = APIPath.operands();
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs.map(
        (snapshot) {
          final data = snapshot.data();
          return data != null ? Operand.fromMap(data) : null;
        },
      ),
    );
  }

  Future<void> assignOperand(Operand operand) =>
      _setData(path: APIPath.operand(uid), data: operand.toMap());

  Future<void> updateOperand(Map<String, dynamic> operand) =>
      _update(path: APIPath.operand(uid), data: operand);

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> _update({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);
  }
}
