abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  StringValidator emailValidator = NonEmptyStringValidator();
  StringValidator passwordValidator = NonEmptyStringValidator();
  String invalidEmailErrorText = 'Adj meg egy érvényes email címet!';
  String invalidPasswordErrorText = 'Jelszó megadása kötelező';
}
