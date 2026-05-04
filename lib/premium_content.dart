import 'package:flutter/material.dart';

class PremiumContent extends StatefulWidget {
  const PremiumContent({super.key});

  @override
  State<PremiumContent> createState() => _PremiumContentState();
}

class _PremiumContentState extends State<PremiumContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildVideoCard(
      BuildContext context, String title, String professor) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.primary.withOpacity(0.15),
                  ),
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        professor,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 💎 Badge Premium
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "PREMIUM",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "🎥 Videoaulas Exclusivas",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildVideoCard(
                context, "Matemática Avançada", "Prof. Especialista"),
            const SizedBox(height: 16),
            buildVideoCard(
                context, "Física para Vestibular", "Prof. Destaque"),
            const SizedBox(height: 16),
            buildVideoCard(
                context, "Redação Nota 1000", "Prof. Convidado"),
          ],
        ),
      ),
    );
  }
}
