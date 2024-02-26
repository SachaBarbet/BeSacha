class Validators {

  static final RegExp _emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Entrer votre adresse mail';
    }

    if (!_emailRegExp.hasMatch(value.toLowerCase().trim())) {
      return 'Entrer une adresse mail valide';
    }

    return null;
  }

  static String? validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Entrer votre nom';
    }

    if (value.length < 3) {
      return 'Le nom doit contenir au moins 3 caractères';
    }

    if (value.length > 32) {
      return 'Le nom doit contenir au maximum 50 caractères';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Entrer votre mot de passe';
    }

    if (!_passwordRegExp.hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins : \n'
          '- 8 caractères\n'
          '- une majuscule\n'
          '- une minuscule\n'
          '- un chiffre';
    }

    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Entrer votre mot de passe';
    }

    if (password != confirmPassword) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }
}