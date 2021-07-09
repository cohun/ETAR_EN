import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/models/counter_model.dart';
import 'package:etar_en/app/models/identifier_model.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/app/models/product_model.dart';
import 'package:etar_en/app/models/role_model.dart';
import 'package:etar_en/services/api_path.dart';
import 'package:flutter/material.dart';

abstract class Database {
  Future<void> createOperand(Operand operand);

  Future<void> createId(String id, String company, String uid);

  Future<void> deleteId(String id, String company, String uid);

  Future<void> deleteCompany(String company, String uid);

  Future<void> getOperand(String uid);

  Future<DocumentSnapshot> getUser(String uid);

  Stream<List<Operand>> operandsStream();

  Stream<List<Operand>> filteredOperandStream({
    @required String company,
  });

  Stream<List<RoleModel>> operandCompaniesStream(String uid, String company);

  Future<RoleModel> retrieveCompany(String uid, String company);
  Future<void> assignRole(String uid, String company, String role);
  Stream<List<Identifier>> identifiersStream(String uid, String company);

  Future<void> updateOperand(Map<String, dynamic> operand);
  Future<CounterModel> retrieveCompanyFromCounter(companyId);
  Future<void> updateCompanies(List<String> _newCompanyList);
  Future<ProductModel> retrieveProductFromId(company, productId);
}

  //***********************************************************************

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createOperand(Operand operand) =>
      _setData(path: APIPath.operand(uid), data: operand.toMap());

  Future<void> createId(String id, String company, String uid) => _setData(
      path: APIPath.productAssignment(uid, company, id),
      data: Identifier(identifier: id).toMap());

  Future<void> deleteId(String id, String company, String uid) =>
      FirebaseFirestore.instance
          .collection(APIPath.identifiersList(uid, company))
          .doc(id)
          .delete();

  Future<void> deleteCompany(String company, String uid) =>
      FirebaseFirestore.instance
          .collection(APIPath.operandCompanies(uid))
          .doc(company)
          .delete();

  Future<void> getOperand(String uid) =>
      FirebaseFirestore.instance.collection('operands').doc(uid).get();

  Future<DocumentSnapshot> getUser(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid).get();

  Future<RoleModel> retrieveCompany(String uid, String company) async {
    final ref =
        FirebaseFirestore.instance.collection(APIPath.operandCompanies(uid));
    RoleModel rol;
    if (ref.doc(company).id == company) {
      return await ref.doc(company).get().then((value) {
        if (value.exists) {
          rol = RoleModel.fromMap(value.data());
        } else {
          rol = RoleModel(role: '', uid: '');
        }
        return rol;
      }
      );
    }
    return rol;
  }

  Stream<List<RoleModel>> operandCompaniesStream(String uid, String company) {
    final path = APIPath.companyRole(uid, company);
    final reference = FirebaseFirestore.instance.collection(path);

    final snapshots = reference.snapshots();
    return snapshots.map(
          (snapshot) {
            if (snapshot.docs.length != 0) {
              return snapshot.docs.map(
                    (snapshot) {
                  final data = snapshot.data();
                  return data != null ? RoleModel.fromMap(data) : null;
                },
              ).toList();
          }
            return null;
    }
    );
  }

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
      'companies', arrayContains: company
    );
    final snapshots = reference.snapshots();
    return snapshots.map(
          (snapshot) => snapshot.docs.map(
            (snapshot) {
          final data = snapshot.data();
          return Operand.fromMap(data);
        },
      ).toList(),
    );
  }

  Stream<List<Identifier>> identifiersStream(String uid, String company) {
    final path = APIPath.identifiersList(uid, company);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
          (snapshot) => snapshot.docs.map(
            (snapshot) {
          final Map<String, dynamic> data = snapshot.data();
          return data != null ? Identifier(identifier: data['identifier']) : null;
        },
      ).toList(),
    );
  }

  Future<void> assignRole(String uid, String company, String role) =>
      _setData(path: APIPath.companyRole(uid, company), data: RoleModel(role: role, uid: uid).toMap());

  Future<void> assignOperand(Operand operand) =>
      _setData(path: APIPath.operand(uid), data: operand.toMap());

  Future<void> updateOperand(Map<String, dynamic> operand) =>
      _update(path: APIPath.operand(uid), data: operand);
  Future<void> _update({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);
  }

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<CounterModel> retrieveCompanyFromCounter(companyId) async {
    final ref = FirebaseFirestore.instance.collection('counter');
    return await ref.doc(companyId.toString()).get().then((value) =>
        CounterModel.fromMap(value.data())
    );
  }

  Future<void> updateCompanies(List<String> _newCompanyList) {
    final reference = FirebaseFirestore.instance.collection('operands');
    return reference
        .doc(uid)
        .update({'companies': _newCompanyList})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<ProductModel> retrieveProductFromId(company, productId) async {
    final ref = FirebaseFirestore.instance.collection('companies/$company/products');
    return await ref.doc(productId).get().then((value) =>
        ProductModel.fromMap(value.data())
    );
  }
}
