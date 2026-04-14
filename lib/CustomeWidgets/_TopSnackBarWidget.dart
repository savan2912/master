import 'package:flutter/material.dart';

class TopSnackBarWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  final VoidCallback onDismissed;

  const TopSnackBarWidget({
    super.key,
    required this.message,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    _startAutoDismiss();
  }

  void _startAutoDismiss() {
    Future.delayed(widget.duration, () async {
      if (!_isClosing) {
        await _closeSnackBar();
      }
    });
  }

  Future<void> _closeSnackBar() async {
    if (_isClosing) return;

    _isClosing = true;

    await _controller.reverse();

    if (mounted) {
      widget.onDismissed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          bottom: false,
          child: SlideTransition(
            position: _animation,
            child: GestureDetector(
              onTap: _closeSnackBar,
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  16,
                  topPadding > 0 ? 8 : 16,
                  16,
                  0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.80),

                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 22,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}