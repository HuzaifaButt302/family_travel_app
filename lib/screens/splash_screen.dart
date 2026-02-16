import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _glowController;
  late AnimationController _rotateController;
  late AnimationController _progressController;
  
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller (bounce effect)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Glow pulse animation (continuous)
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Rotate animation (continuous subtle rotation)
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    )..repeat();

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo scale with bounce
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Text fade animation
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Glow pulse
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Subtle rotation
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_rotateController);

    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation
    _logoController.forward();
    _progressController.forward();

    // Wait a bit then start text animation
    await Future.delayed(const Duration(milliseconds: 900));
    _textController.forward();

    // Navigate to home screen after all animations
    await Future.delayed(const Duration(milliseconds: 2800));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _glowController.dispose();
    _rotateController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                  Color(0xFFf093fb),
                  Color(0xFFf5576c),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated particles/dots in background
                ...List.generate(20, (index) {
                  return _buildFloatingParticle(index);
                }),
                
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with rotating glow rings
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer rotating glow ring
                          AnimatedBuilder(
                            animation: _rotateAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotateAnimation.value,
                                child: AnimatedBuilder(
                                  animation: _glowAnimation,
                                  builder: (context, child) {
                                    return Container(
                                      width: 200 + (_glowAnimation.value * 20),
                                      height: 200 + (_glowAnimation.value * 20),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1 * _glowAnimation.value),
                                          width: 2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          
                          // Middle rotating glow ring (opposite direction)
                          AnimatedBuilder(
                            animation: _rotateAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: -_rotateAnimation.value * 0.7,
                                child: AnimatedBuilder(
                                  animation: _glowAnimation,
                                  builder: (context, child) {
                                    return Container(
                                      width: 170 + (_glowAnimation.value * 15),
                                      height: 170 + (_glowAnimation.value * 15),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.pink.withOpacity(0.15 * _glowAnimation.value),
                                          width: 2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          
                          // Animated Logo Container
                          AnimatedBuilder(
                            animation: _logoAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _logoAnimation.value,
                                child: AnimatedBuilder(
                                  animation: _glowAnimation,
                                  builder: (context, child) {
                                    return Hero(
                                      tag: 'app_logo',
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(40),
                                          boxShadow: [
                                            // Pulsing white glow
                                            BoxShadow(
                                              color: Colors.white.withOpacity(0.6 * _glowAnimation.value),
                                              blurRadius: 50 * _glowAnimation.value,
                                              spreadRadius: 15 * _glowAnimation.value,
                                            ),
                                            // Pink glow
                                            BoxShadow(
                                              color: Color(0xFFf093fb).withOpacity(0.4 * _glowAnimation.value),
                                              blurRadius: 40 * _glowAnimation.value,
                                              spreadRadius: 10 * _glowAnimation.value,
                                            ),
                                            // Purple glow
                                            BoxShadow(
                                              color: Color(0xFF764ba2).withOpacity(0.3 * _glowAnimation.value),
                                              blurRadius: 30 * _glowAnimation.value,
                                              spreadRadius: 5 * _glowAnimation.value,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(0),
                                        child: Image.asset(
                                          'assets/logo/APP.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      // Animated Text with premium styling
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _textAnimation,
                          child: Column(
                            children: [
                              // Title with shimmer effect
                              AnimatedBuilder(
                                animation: _glowAnimation,
                                builder: (context, child) {
                                  return ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.white.withOpacity(0.8 + (0.2 * _glowAnimation.value)),
                                          Colors.white,
                                        ],
                                        stops: [
                                          0.0,
                                          _glowAnimation.value,
                                          1.0,
                                        ],
                                      ).createShader(bounds);
                                    },
                                    child: const Text(
                                      'Family Travel Vault',
                                      style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black38,
                                            offset: Offset(2, 2),
                                            blurRadius: 8,
                                          ),
                                          Shadow(
                                            color: Colors.white38,
                                            offset: Offset(-1, -1),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 18),
                              
                              // Subtitle
                              Text(
                                'Manage Your Family\'s\nTravel Documents',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white.withOpacity(0.95),
                                  height: 1.6,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 50),
                              
                              // Premium Progress Indicator
                              _buildPremiumProgressIndicator(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Premium circular progress with percentage
  Widget _buildPremiumProgressIndicator() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                
                // Progress circle
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: _progressController.value,
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),
                ),
                
                // Percentage text
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Text(
                      '${(_progressController.value * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Loading text
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7 + (0.3 * _glowAnimation.value)),
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w300,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Floating particles animation
  Widget _buildFloatingParticle(int index) {
    final random = math.Random(index);
    final size = 3.0 + random.nextDouble() * 4;
    final left = random.nextDouble() * 400;
    final top = random.nextDouble() * 800;
    
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Positioned(
          left: left,
          top: top + (math.sin(_glowController.value * 2 * math.pi + index) * 30),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1 + (0.3 * _glowAnimation.value)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2 * _glowAnimation.value),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

