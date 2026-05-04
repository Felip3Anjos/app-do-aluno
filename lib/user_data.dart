class UserData {
  static List<String> validUsernames = ['user1', 'user2'];
  static List<String> validPasswords = ['pass1', 'pass2'];

  // Adiciona um novo utilizador às listas
  static void addUser(String username, String password) {
    validUsernames.add(username);
    validPasswords.add(password);
  }

  // Verifica se um utilizador já existe com a senha correta
  static bool userExists(String username, String password) {
    for (int i = 0; i < validUsernames.length; i++) {
      if (validUsernames[i] == username && validPasswords[i] == password) {
        return true;
      }
    }
    return false;
  }

  // Atualiza a senha de um utilizador existente
  static void updatePassword(String username, String newPassword) {
    int userIndex = validUsernames.indexOf(username);
    if (userIndex != -1) {
      validPasswords[userIndex] = newPassword;
    }
  }
}
