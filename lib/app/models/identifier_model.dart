class Identifier {
  final String identifier;

  Identifier({
    this.identifier,
  });

  factory Identifier.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String identifier = data['identifier'];

    return Identifier(
      identifier: identifier,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
    };
  }
}
