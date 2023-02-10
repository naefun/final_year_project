class Validator {
  static String? validateName({String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({String? email}) {
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({String? password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }

    static String? validateUserType({String? userType}) {
    if (userType == null) {
      return 'Please select a user type';
    }
    return null;
  }

  static validateDate({String? date}) {
    RegExp dateRegEx = RegExp(
    r"^(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)\d\d$");
  
    if (date==null || date.isEmpty) {
      return "Date can't be empty, use the format: DD/MM/YYYY";
    } else if (!dateRegEx.hasMatch(date)) {
      return "Enter a valid date using the format: DD/MM/YYYY";
    }

    return null;
  }
}