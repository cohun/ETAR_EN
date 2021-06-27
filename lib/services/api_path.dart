class APIPath {
  static String operand(String uid) => '/operands/$uid';

  static String operands() => '/operands';

  static String operandCompanies(String uid) => '/operands/$uid/companies';

  static String companyRole(String uid, String company) => 'operands/$uid/companies/$company';

  static String productAssignment(
          String uid, String company, String identifier) =>
      'operands/$uid/companies/$company/assignments/$identifier';
}
