import 'dart:math';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class FlippableCard extends StatefulWidget {
  final PlayingCard? card;
  final bool showBack;
  final VoidCallback? onTap;

  const FlippableCard({
    super.key,
    required this.card,
    this.showBack = false,
    this.onTap,
  });

  @override
  State<FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isBack = true;
  PlayingCard? _displayedCard;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));
    _displayedCard = widget.card;
    _isBack = widget.showBack;
    if (!_isBack) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlippableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBack != oldWidget.showBack || widget.card != oldWidget.card) {
      if (widget.showBack) {
         _controller.reverse();
      } else {
         _displayedCard = widget.card;
         _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isFrontMoving = angle >= pi / 2;
          
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFrontMoving
                ? Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildFront(),
                  )
                : _buildBack(),
          );
        },
      ),
    );
  }

  Widget _buildBack() {
    return PlayingCardView(
      card: PlayingCard(Suit.spades, CardValue.ace),
      showBack: true,
      elevation: 8,
    );
  }

  Widget _buildFront() {
    if (_displayedCard == null) return _buildBack(); // Should not happen if logic correct
    return PlayingCardView(
      card: _displayedCard!,
      elevation: 8,
    );
  }
}
