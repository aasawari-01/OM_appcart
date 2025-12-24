import 'package:flutter/material.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/view/screens/login_view.dart';

import '../../utils/size_config.dart';
import '../widgets/cust_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int currentPage = 0;

  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  late Tween<double> _progressTween;
  bool _isAdvancing = false;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Stay on Top of Operations",
      "description":
      "Monitor station activities and train schedules in real time.",
      "image": "assets/images/onboarding1.png",
      "arrow": "assets/images/arrow1.png",
      "background": "assets/images/background1.png",
    },
    {
      "title": "Simplify Maintenance Tasks",
      "description":
      "Report failures and manage PTWs and inspections on the go.",
      "image": "assets/images/onboarding2.png",
      "arrow": "assets/images/arrow2.png",
      "background": "assets/images/background2.png",
    },
    {
      "title": "Connected & In \nControl",
      "description":
      "Get instant alerts and updates to act quickly and efficiently.",
      "image": "assets/images/onboarding3.png",
      "arrow": "assets/images/arrow3.png",
      "background": "assets/images/background3.png",
    },
  ];

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );
    // Initialize progress to first page (1/length)
    final double initialProgress = 1 / onboardingData.length;
    _progressTween = Tween<double>(begin: initialProgress, end: initialProgress);

    // Start with initial progress value set
    _progressController.value = 1.0;
  }

  @override
  void dispose() {
    _progressController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                final double previous = (currentPage + 1) / onboardingData.length;
                final double next = (index + 1) / onboardingData.length;
                // Ensure controller is at start before animating to avoid visual jump
                _progressController.stop();
                _progressController.value = 0;
                setState(() {
                  currentPage = index;
                  _progressTween = Tween<double>(begin: previous, end: next);
                });
                _progressController.forward();
              },
              itemBuilder: (context, index) {
                return OnboardingContent(
                  title: onboardingData[index]["title"]!,
                  description: onboardingData[index]["description"]!,
                  image: onboardingData[index]["image"]!,
                );
              },
            ),
            Positioned(
              bottom: 0,
              child: Image.asset(
                onboardingData[currentPage]["background"]!,
                // height: 8 * SizeConfig.heightMultiplier,
                 width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) =>  LoginView()),
                  );
                },
                child: CustText(
                  name: 'Skip',
                  color: AppColors.textColor,
                  size: 1.8,
                  fontWeightName: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (_isAdvancing) return;
                      _isAdvancing = true;
                      try {
                        nextPage();
                      } finally {
                        _isAdvancing = false;
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        final double size = 8 * SizeConfig.heightMultiplier;
                        final double displayedProgress = _progressTween.transform(_progressAnimation.value);
                        return SizedBox(
                          height: size,
                          width: size,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: Size.square(size),
                                painter: _RingPainter(
                                  progress: displayedProgress,
                                  color: AppColors.blue,
                                  strokeWidth: 3.0,
                                ),
                              ),
                              Container(
                                height: size * 0.72,
                                width: size * 0.72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.blue,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.blue.withOpacity(0.35),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: size * 0.32,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title, description, image;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8 * SizeConfig.widthMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 12 * SizeConfig.heightMultiplier),
          Image.asset(image, width: MediaQuery.of(context).size.width,), // Replace with your assets
           SizedBox(height: 6 * SizeConfig.heightMultiplier),
          CustText(
           name: title,
            size: 3.0,
            color: AppColors.textColor5,
            textAlign: TextAlign.center,
            fontWeightName: FontWeight.w700,
          ),
          const SizedBox(height: 12),
          CustText(
            name: description,
            color: AppColors.textColor,
            size: 1.9,
            fontWeightName: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (size.shortestSide - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color.withOpacity(0.2)
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final Paint foregroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Background ring
    canvas.drawCircle(center, radius, backgroundPaint);

    // Foreground progress arc
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    final double startAngle = -90 * 3.1415926535897932 / 180; // top
    final double sweepAngle = 2 * 3.1415926535897932 * progress;
    canvas.drawArc(rect, startAngle, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}