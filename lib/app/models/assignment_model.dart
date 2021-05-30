class Assignment {
  final String company;
  final String identifier;
  final String uid;

  Assignment({
    this.uid,
    this.company,
    this.identifier,
  });

  factory Assignment.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String company = data['company'];
    final String identifier = data['identifier'];
    final String uid = data['uid'];

    return Assignment(
      company: company,
      identifier: identifier,
      uid: uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'identifier': identifier,
      'uid': uid,
    };
  }
}
