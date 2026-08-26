import 'dart:ui';
import 'package:flutter/material.dart';

class TopSnackBarWidget extends StatefulWidget {
  final String title;
  final String message;
  final Duration duration;
  final VoidCallback onDismissed;

  const TopSnackBarWidget({
    super.key,
    this.title = "Error",
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
      duration: const Duration(milliseconds: 400),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -1.2),
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
      if (!_isClosing && mounted) {
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
                  topPadding > 0 ? 4 : 12,
                  16,
                  0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.005),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.005),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.0005),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title.toLowerCase() == "fail" || widget.title.toLowerCase() == "error")
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(Icons.error_outline, color: Colors.red, size: 24),
                            ),
                          if (widget.title.toLowerCase() == "pass" || widget.title.toLowerCase() == "success")
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(Icons.check_circle, color: Colors.green, size: 24),
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.message,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.75),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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