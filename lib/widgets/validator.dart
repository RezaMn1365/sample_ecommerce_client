import 'package:flutter/cupertino.dart';

class Validator {
  bool hasMinLength(String password, int minLength) {
    return password.length >= minLength ? true : false;
  }

  /// Checks if password has at least uppercaseCount uppercase letter matches
  bool hasMinUppercase(String password, int uppercaseCount) {
    String pattern = '^(.*?[A-Z]){' + uppercaseCount.toString() + ',}';
    return password.contains(RegExp(pattern));
  }

  /// Checks if password has at least numericCount numeric character matches
  bool hasMinNumericChar(String password, int numericCount) {
    String pattern = '^(.*?[0-9]){' + numericCount.toString() + ',}';
    return password.contains(RegExp(pattern));
  }

  //Checks if password has at least specialCount special character matches
  bool hasMinSpecialChar(String password, int specialCount) {
    String pattern =
        r"^(.*?[$&+,\:;/=?@#|'<>.^*()_%!-]){" + specialCount.toString() + ",}";
    return password.contains(RegExp(pattern));
  }

  bool hasMinLatinOnly(String name, int nameCount) {
    // var exp = RegExp(r'^([A-Za-z0-9]){' + nameCount.toString() + ',}');
    // var match = exp.firstMatch(name);
    String pattern = r'^(.*?[A-Za-z0-9]){' + nameCount.toString() + ',}';
    // debugPrint('${name.contains(RegExp(pattern))}');
    
    // debugPrint('${Regex.M');
    return name.contains(RegExp(pattern));
  }
}
