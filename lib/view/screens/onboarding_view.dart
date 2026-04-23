import 'package:flutter/material.dart';
import 'package:om_appcart/constants/app_images.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/constants/strings.dart';
import 'package:om_appcart/feature/auth_login/view/login_view.dart';

import '../../utils/responsive_helper.dart';
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
      "title": AppStrings.onboardingTitle1,
      "description": AppStrings.onboardingDesc1,
      "image": AppAssets.onboarding1,
      "arrow": AppAssets.onboardingArrow1,
      "background": AppAssets.onboardingBackground1,
    },
    {
      "title": AppStrings.onboardingTitle2,
      "description": AppStrings.onboardingDesc2,
      "image": AppAssets.onboarding2,
      "arrow": AppAssets.onboardingArrow2,
      "background": AppAssets.onboardingBackground2,
    },
    {
      "title": AppStrings.onboardingTitle3,
      "description": AppStrings.onboardingDesc3,
      "image": AppAssets.onboarding3,
      "arrow": AppAssets.onboardingArrow3,
      "background": AppAssets.onboardingBackground3,
    },
  ];

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
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
    final double initialProgress = 1 / onboardingData.length;
    _progressTween = Tween<double>(begin: initialProgress, end: initialProgress);

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
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              final double previous = (currentPage + 1) / onboardingData.length;
              final double next = (index + 1) / onboardingData.length;
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
            left: 0,
            right: 0,
            child: Image.asset(
              onboardingData[currentPage]["background"]!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: ResponsiveHelper.spacing(context, 30),
            right: ResponsiveHelper.spacing(context, 10),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>  LoginView()),
                );
              },
              child: CustText(
                name: AppStrings.skip,
                color: AppColors.textColor,
                size: 1.8,
                fontWeightName: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: ResponsiveHelper.spacing(context, 50),
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
                      final double size = ResponsiveHelper.spacing(context, 80);
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
    );
  }

  Widget buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: currentPage == index ? AppColors.blue : AppColors.grey,
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
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.spacing(context, 32)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: ResponsiveHelper.spacing(context, 96)),
          Image.asset(
            image,
            width: double.infinity,
            height: ResponsiveHelper.height(context, 300), // Added responsive height constraint
            fit: BoxFit.contain,
          ),
          SizedBox(height: ResponsiveHelper.spacing(context, 48)),
          CustText(
           name: title,
            size: 3.0,
            color: AppColors.textColor5,
            textAlign: TextAlign.center,
            fontWeightName: FontWeight.w700,
          ),
          SizedBox(height: ResponsiveHelper.spacing(context, 12)),
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