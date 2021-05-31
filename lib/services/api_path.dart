class APIPath {
  static String operand(String uid) => '/operands/$uid';

  static String operands() => '/operands';

  static String productAssignment(
          String uid, String company, String identifier) =>
      'operands/$uid/companies/$company/assignments/$identifier';
}
