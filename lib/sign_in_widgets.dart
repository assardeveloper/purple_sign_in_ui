import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors for the purple sign in design
const Color kBackground = Color(0xFFF4EEF1);
const Color kPurple = Color(0xFF4B3578);
const Color kViolet = Color(0xFF7B4FD6);
const Color kFieldFill = Colors.white;
const Color kInk = Color(0xFF2F2A38);
const Color kGrey = Color(0xFF8E8794);
const Color kPink = Color(0xFFE8456F);

const LinearGradient kPurpleGradient = LinearGradient(
  colors: [kPurple, kViolet],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

TextStyle outfit(double size, {FontWeight weight = FontWeight.w400, Color color = kInk}) {
  return GoogleFonts.outfit(fontSize: size, fontWeight: weight, color: color);
}

// Purple gradient circle with a background colored circle laid over part of it,
// which leaves the curved "bitten" blob shape seen in the corners.
// It drifts and turns slowly so the screen never looks static.
class CornerBlob extends StatefulWidget {
  const CornerBlob({
    super.key,
    required this.size,
    required this.cutSize,
    required this.cutOffset,
    this.seconds = 6,
  });

  final double size;
  final double cutSize;
  final Offset cutOffset;
  final int seconds;

  @override
  State<CornerBlob> createState() => _CornerBlobState();
}

class _CornerBlobState extends State<CornerBlob> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: widget.seconds),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Transform.translate(
          offset: Offset(8 * t, 10 * t),
          child: Transform.rotate(angle: 0.12 * t, child: child),
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                gradient: kPurpleGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kViolet.withValues(alpha: 0.35),
                    blurRadius: 30,
                  ),
                ],
              ),
            ),
            Positioned(
              left: widget.cutOffset.dx,
              top: widget.cutOffset.dy,
              child: Container(
                width: widget.cutSize,
                height: widget.cutSize,
                decoration: BoxDecoration(color: kBackground, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small dot or ring that bobs up and down, used as sparkle decoration
class FloatingDot extends StatefulWidget {
  const FloatingDot({
    super.key,
    required this.size,
    required this.color,
    this.ring = false,
    this.phase = 0,
  });

  final double size;
  final Color color;
  final bool ring;
  final double phase;

  @override
  State<FloatingDot> createState() => _FloatingDotState();
}

class _FloatingDotState extends State<FloatingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final wave = math.sin((_controller.value + widget.phase) * 2 * math.pi);
        return Transform.translate(offset: Offset(0, 6 * wave), child: child);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.ring ? null : widget.color,
          border: widget.ring ? Border.all(color: widget.color, width: 2.5) : null,
        ),
      ),
    );
  }
}

// Fades and slides its child up while [animation] moves through [start]..[start + 0.4]
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.animation,
    required this.start,
    required this.child,
  });

  final Animation<double> animation;
  final double start;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(start, math.min(start + 0.4, 1), curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        return Opacity(
          opacity: curved.value,
          child: Transform.translate(offset: Offset(0, 30 * (1 - curved.value)), child: child),
        );
      },
      child: child,
    );
  }
}

// White rounded input that glows purple while focused,
// with an eye toggle when it is a password field
class SignInField extends StatefulWidget {
  const SignInField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
  });

  final String hint;
  final IconData icon;
  final bool isPassword;

  @override
  State<SignInField> createState() => _SignInFieldState();
}

class _SignInFieldState extends State<SignInField> {
  final FocusNode _focus = FocusNode();
  bool _hidden = true;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: kFieldFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: focused ? kViolet : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: kViolet.withValues(alpha: focused ? 0.25 : 0.08),
            blurRadius: focused ? 20 : 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        focusNode: _focus,
        obscureText: widget.isPassword && _hidden,
        cursorColor: kViolet,
        style: outfit(16),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: outfit(16, color: kGrey),
          prefixIcon: Icon(widget.icon, color: focused ? kViolet : kInk, size: 20),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () => setState(() => _hidden = !_hidden),
                  icon: Icon(
                    _hidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: kGrey,
                    size: 20,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// Gradient button with a soft glow that shrinks a little while pressed
class GradientButton extends StatefulWidget {
  const GradientButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: kPurpleGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: kViolet.withValues(alpha: _pressed ? 0.25 : 0.45),
                blurRadius: _pressed ? 10 : 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: outfit(16, weight: FontWeight.w600, color: Colors.white)
                    .copyWith(letterSpacing: 1.5),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget forgotPasswordLink(VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Text("Forgot Password?", style: outfit(14, weight: FontWeight.w500, color: kGrey)),
  );
}

Widget signUpPrompt(VoidCallback onTap) {
  return Wrap(
    alignment: WrapAlignment.center,
    children: [
      Text("don't have a account? ", style: outfit(14, color: kGrey)),
      GestureDetector(
        onTap: onTap,
        child: Text("SIGN UP", style: outfit(14, weight: FontWeight.w700, color: kPink)),
      ),
    ],
  );
}
