import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProductModel {
  final String productGroup;
  final String type;
  final String length;
  final String description;
  final String identifier;
  final String nfc;
  final String company;
  final String site;
  final String person;
  final String capacity;
  final String manufacturer;
  final String extraNr;
  final String productionDate;

  ProductModel({
    @required this.productGroup,
    @required this.type,
    @required this.length,
    @required this.description,
    @required this.identifier,
    this.nfc,
    @required this.company,
    this.site,
    this.person,
    @required this.capacity,
    this.manufacturer,
    this.extraNr,
    this.productionDate,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String productGroup = data['productGroup'];
    final String type = data['type'];
    final String length = data['length'];
    final String description = data['description'];
    final String identifier = data['identifier'];
    final String nfc = data['nfc'];
    final String company = data['company'];
    final String site = data['site'];
    final String person = data['person'];
    final String capacity = data['capacity'];
    final String manufacturer = data['manufacturer'];
    final String extraNr = data['extraNr'];
    final String productionDate = data['productionDate'];

    return ProductModel(
      productGroup: productGroup,
      type: type,
      length: length,
      description: description,
      identifier: identifier,
      nfc: nfc,
      company: company,
      site: site,
      person: person,
      capacity: capacity,
      manufacturer: manufacturer,
      extraNr: extraNr,
      productionDate: productionDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productGroup': productGroup,
      'type': type,
      'length': length,
      'description': description,
      'identifier': identifier,
      'nfc': nfc,
      'company': company,
      'site': site,
      'person': person,
      'capacity': capacity,
      'manufacturer': manufacturer,
      'extraNr': extraNr,
      'productionDate': productionDate,
    };
  }
}
