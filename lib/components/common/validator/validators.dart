class Validators {
  static String generalValidate(String value) {
    if (value.isEmpty)
      return 'You must fill in this field';
    else
      return null;
  }

  static String validateUsername(String value) {
    if (value.length < 3)
      return 'Username must be more than two charaters';
    else
      return null;
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  static String phoneNumberValidator(String value) {
    Pattern pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Phone Number';
    else
      return null;
  }
}
