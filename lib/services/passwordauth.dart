class PasswordAuth {
  // RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)")
    String? validatePass(value) {
    if (value.isEmpty) {
      return 'Required *';
    } else if (value.length < 8) {
      return 'Enter atleast 8 characters';
    } else if (value.length > 15) {
      return "Should not exceed 15 characters";
    } else {
      return null;
    }
  }

}