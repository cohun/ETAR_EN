class Assignees {
  final String role;
  final String name;

  Assignees({
    this.name,
    this.role,
  });

  factory Assignees.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String role = data['role'];
    final String name = data['name'];

    return Assignees(
      role: role,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'name': name,
    };
  }
}
