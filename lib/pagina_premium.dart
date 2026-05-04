import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../premium_provider.dart';
import 'premium_content.dart';
import 'premium_lock.dart';

class PaginaPremium extends StatelessWidget {
  const PaginaPremium({super.key});

  @override
  Widget build(BuildContext context) {
    final premium = Provider.of<PremiumProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium"),
      ),
      body: premium.isPremium
          ? const PremiumContent()
          : const PremiumLock(),
    );
  }
}
