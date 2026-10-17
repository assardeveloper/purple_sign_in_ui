import 'package:flutter/material.dart';

import 'sign_in_widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  // drives the staggered entrance of the form
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1400),
  )..forward();

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          const Positioned(
            top: -60,
            right: -50,
            child: CornerBlob(
              size: 160,
              cutSize: 1130,
              cutOffset: Offset(-85, 50),
            ),
          ),
          const Positioned(
            bottom: -70,
            left: -60,
            child: CornerBlob(
              size: 220,
              cutSize: 120,
              cutOffset: Offset(150, 10),
              seconds: 8,
            ),
          ),

          const Positioned(
            top: 150,
            right: 60,
            child: FloatingDot(size: 14, color: kPink, ring: true),
          ),
          const Positioned(
            top: 210,
            left: 40,
            child: FloatingDot(size: 8, color: kViolet, phase: 0.3),
          ),
          const Positioned(
            bottom: 190,
            right: 50,
            child: FloatingDot(size: 10, color: kPurple, phase: 0.6),
          ),
          const Positioned(
            bottom: 120,
            right: 120,
            child: FloatingDot(
              size: 18,
              color: kViolet,
              ring: true,
              phase: 0.8,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeSlideIn(
                      animation: _intro,
                      start: 0,
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            kPurpleGradient.createShader(bounds),
                        child: Text(
                          "SignIn",
                          style: outfit(
                            36,
                            weight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    FadeSlideIn(
                      animation: _intro,
                      start: 0.08,
                      child: Text(
                        "Welcone back! Please sign in to contiune",
                        style: outfit(15, color: kGrey),
                      ),
                    ),
                    SizedBox(height: 32),
                    FadeSlideIn(
                      animation: _intro,
                      start: 0.16,
                      child: SignInField(
                        hint: "Username",
                        icon: Icons.person_rounded,
                      ),
                    ),
                    SizedBox(height: 18),
                    FadeSlideIn(
                      animation: _intro,
                      start: 0.24,
                      child: SignInField(
                        hint: "Password",
                        icon: Icons.lock_rounded,
                        isPassword: true,
                      ),
                    ),
                    SizedBox(height: 28),
                    FadeSlideIn(
                      animation: _intro,
                      start: 0.32,
                      child: GradientButton(label: "SIGN IN", onTap: () {}),
                    ),
                    SizedBox(height: 30),
                    FadeSlideIn(
                      animation: _intro,
                      start: 0.42,
                      child: Center(child: forgotPasswordLink(() {})),
                    ),
                    SizedBox(height: 22),
                    FadeSlideIn(
                      animation: _intro,
                      start: 0.5,
                      child: Center(child: signUpPrompt(() {})),
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
