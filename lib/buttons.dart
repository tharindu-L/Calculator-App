import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Color color;
  final Color textColor;
  final dynamic content; // Accepts either String or IconData
  final double borderRadius;
  final VoidCallback? buttonTapped;

  const MyButton({super.key, 
    required this.color,
    required this.textColor,
    required this.content,
    this.borderRadius = 50,
    this.buttonTapped,
  });

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.buttonTapped,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0, // Scale effect for pressed state
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                boxShadow: _isPressed
                    ? [] // No shadow when pressed
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(4, 6),
                  ),
                ],
              ),
              child: Center(
                child: widget.content is String
                    ? Text(
                  widget.content,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    : Icon(
                  widget.content,
                  color: widget.textColor,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
