import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/models/counter_model.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/services/api_path.dart';
import 'package:flutter/material.dart';

abstract class Database {
  Future<void> createOperand(Operand operand);

  Future<void> getOperand(String uid);
  Future<DocumentSnapshot> getUser(String uid);

  Stream<List<Operand>> operandsStream();
  Stream<List<Operand>> filteredOperandStream({
    @required String company,
  });

  Future<void> updateOperand(Map<String, dynamic> operand);
  Future<CounterModel> retrieveCompanyFromCounter(companyId);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createOperand(Operand operand) =>
      _setData(path: APIPath.operand(uid), data: operand.toMap());

  Future<void> getOperand(String uid) =>
      FirebaseFirestore.instance.collection('operands').doc(uid).get();
  Future<DocumentSnapshot> getUser(String uid) =>
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
      ).toList(),
    );
  }
  Stream<List<Operand>> filteredOperandStream ( {
    @required String company,
  }) {
    final path = APIPath.operands();
    final reference = FirebaseFirestore.instance.collection(path).where(
      'companies', arrayContains: 'first'
    );
    final snapshots = reference.snapshots();
    // snapshots.listen((event) {
    //   event.docs.forEach((element) {
    //     print(element.data());
    //     final dat = Operand.fromMap(element.data());
    //     print(dat.companies);
    //   });
    // });
    return snapshots.map(
          (snapshot) => snapshot.docs.map(
            (snapshot) {
          final data = snapshot.data();
          return Operand.fromMap(data);
        },
      ).toList(),
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

  Future<CounterModel> retrieveCompanyFromCounter(companyId) async {
    final ref = FirebaseFirestore.instance.collection('counter');
    return await ref.doc(companyId.toString()).get().then((value) =>
        CounterModel.fromMap(value.data())
    );
  }
}
