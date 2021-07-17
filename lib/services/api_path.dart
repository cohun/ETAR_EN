class APIPath {
  static String operand(String uid) => '/operands/$uid';

  static String operands() => '/operands';

  static String operandCompanies(String uid) => '/operands/$uid/companies';

  static String companyRole(String uid, String company) =>
      'operands/$uid/companies/$company';

  static String productAssignment(
          String uid, String company, String identifier) =>
      'operands/$uid/companies/$company/identifiers/$identifier';

  static String logAssignment(String company, String identifier, String uid) =>
      'companies/$company/products/$identifier/assignees/$uid';

  static String assignees(String company, String identifier) =>
      'companies/$company/products/$identifier/assignees';

  static String products(String company) => 'companies/$company/products';

  static String logEntries(String date, String company, String identifier) =>
      'companies/$company/products/$identifier/entries/$date';

  static String identifiersList(String uid, String company) =>
      'operands/$uid/companies/$company/identifiers';
}
