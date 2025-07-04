import 'package:flutter/material.dart';

class ModernTypingIndicator extends StatefulWidget {
  const ModernTypingIndicator({super.key});

  @override
  State<ModernTypingIndicator> createState() => _ModernTypingIndicatorState();
}

class _ModernTypingIndicatorState extends State<ModernTypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B35),
                  Color(0xFFFF8E53),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'M',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 6,
                            height: 6 + (4 * (_animation.value + index * 0.3) % 1.0),
                            decoration: BoxDecoration(
                              color: Color.lerp(
                                Colors.grey[400],
                                const Color(0xFFFF6B35),
                                (_animation.value + index * 0.3) % 1.0,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'typing...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}