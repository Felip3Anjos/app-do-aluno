import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../premium_provider.dart';

class PremiumLock extends StatelessWidget {
  const PremiumLock({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.workspace_premium,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  "Plano Premium",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Desbloqueie videoaulas exclusivas e conteúdos avançados.",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Provider.of<PremiumProvider>(context,
                            listen: false)
                        .ativarPremium();
                  },
                  child: const Text("Ativar Premium"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
