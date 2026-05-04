import 'package:flutter/material.dart';
import 'package:mobile/usuario.dart';

class UsuarioProvider with ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  void setUsuario(Usuario usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  void logout() {
    _usuario = null;
    notifyListeners();
  }
}
