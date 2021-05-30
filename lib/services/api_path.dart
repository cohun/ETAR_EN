class APIPath {
  static String operand(String uid) => '/operands/$uid';

  static String productAssignment(String uid, String counter) =>
      'operands/$uid/companies/$counter';
}
