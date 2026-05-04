import 'package:flutter/material.dart';

class PremiumProvider extends ChangeNotifier {
  bool _isPremium = false;

  bool get isPremium => _isPremium;

  void ativarPremium() {
    _isPremium = true;
    notifyListeners();
  }

  void desativarPremium() {
    _isPremium = false;
    notifyListeners();
  }
}
