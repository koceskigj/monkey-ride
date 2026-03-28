import 'package:flutter/material.dart';

class NearbyBadge extends StatefulWidget {
  const NearbyBadge({super.key});

  @override
  State<NearbyBadge> createState() => _NearbyBadgeState();
}

class _NearbyBadgeState extends State<NearbyBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.45,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Text(
        'Nearby',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.green.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}